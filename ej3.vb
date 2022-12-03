' https://godbolt.org/z/zoWsE11Ev
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

    Sub Main()
        Dim Line, FirstHalf, SecondHalf As String
        Dim Sum As Int64
        Dim FirstSet, SecondSet As Int64
        Dim CurrentChar As Char
        Sum = 0
        Do While true
            FirstSet = 0
            SecondSet = 0
            Line = Console.ReadLine()
            FirstHalf = Line.substring(0, Line.Length / 2)
            SecondHalf = Line.substring(Line.Length / 2, Line.Length / 2)
            For Each CurrentChar In FirstHalf
                FirstSet = FirstSet Or CharToBit(CurrentChar)
            Next
            For Each CurrentChar In SecondHalf
                SecondSet = SecondSet Or CharToBit(CurrentChar)
            Next
            Sum = Sum + BitToCharNum(FirstSet And SecondSet) + 1
            Console.WriteLine(Sum)
        Loop
    End Sub
End Module
