#!/usr/bin/env python3
# kitty.conf 의 `geninclude` 로 실행되어 map 설정을 출력한다.
#
# 한글 입력기 상태에서는 ctrl+<영문키> 가 ctrl+<한글자모>(예: ctrl+ㅠ) 로 들어와
# 셸·herdr·nvim 에 제어 문자가 전달되지 않는다.
# kitty 에는 이를 전역으로 푸는 옵션이 없고 map 마다 --allow-fallback=ascii 를
# 붙여야 하므로, "ctrl+<물리 키> 는 그 키의 영문 ctrl 조합으로 보낸다" 는
# 규칙 하나로 모든 영문 키의 매핑을 생성한다.
#
# prefix(ctrl+b) 뒤에 누르는 키는 herdr 의
# experimental.switch_ascii_input_source_in_prefix 가 처리하므로 여기서 다루지 않는다.
import string

for key in string.ascii_lowercase:
    print(f"map --allow-fallback=ascii ctrl+{key} send_key ctrl+{key}")
