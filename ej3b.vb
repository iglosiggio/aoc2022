' https://godbolt.org/z/fod4f3r5o
Imports System

Module Program
    Function CharToBit(c As Char) As Int64
        Dim CharNum As Integer
        CharNum = Asc(c)
        If (Asc("a"c) <= CharNum And CharNum <= Asc("z"c)) Then
            Return 1L << (CharNum - Asc("a"c))
        Else
            Return 1L << (26 + CharNum - Asc("A"c))
        End If
    End Function

    Function BitToCharNum(num As Int64) As Int64
        Dim b As Int64
        For b = 0 To 63
            If (num And (1L << b)) = (1L << b) Then Return b
        Next b
        Return 0
    End Function

    Function CharNumToChar(charnum As Int64) As Char
        If charnum < 26 Then
            Return Chr(charnum + Asc("a"c))
        Else
            Return Chr(charnum - 26 + Asc("A"c))
        End If
    End Function

    Function ReadLine() As Int64
        Dim Line As String
        Dim CharSet As Int64
        CharSet = 0
        Line = Console.ReadLine()
        For Each CurrentChar In Line
            CharSet = CharSet Or CharToBit(CurrentChar)
        Next
        Return CharSet
    End Function

    Sub Main()
        Dim Line1, Line2, Line3 As Int64
        Dim Sum As Int64
        Sum = 0
        Do While true
            Line1 = ReadLine()
            Line2 = ReadLine()
            Line3 = ReadLine()
            Sum = Sum + BitToCharNum(Line1 And Line2 And Line3) + 1
            Console.WriteLine(Sum)
        Loop
    End Sub
End Module
