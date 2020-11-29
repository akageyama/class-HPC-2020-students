program sample06
  implicit none
  character(len=3) :: str3
  character(len=4) :: str4
  character(len=7) :: str7
  character(len=*), parameter :: MESSAGE = "Hello!" 
                       ! 小文字のmessageとしても同じだが
                       ! 定数文字列であることがわかりやすいように
                       ! すべて大文字で書いている。

  str3 = "abc"   ! ダブルクォーテーションでも
  str4 = 'defg'  ! シングルクォーテーションでもOK
  str7 = str3 // str4  ! 文字列の連結

  print *, "str3//str4 --> str7 = ", str7
  print *, "First two letters of str7 = ", str7(1:2)

  str7(3:7) = "     "    ! 3文字目から7文字目を空白で埋める
  print *, "str7 = ", str7
  print *, str7 // str3  ! => "ab     abc"
  print *, trim(str7) // str3  
                   ! => "ababc"  trim関数は末尾の空白をとる
  print *, "Length of MESSAGE = ", len(MESSAGE) 
                   ! 文字長を返す関数
end program sample06
