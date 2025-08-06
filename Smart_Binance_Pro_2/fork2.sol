// SPDX-License-Identifier: Unlicensed
pragma solidity >=0.4.22 <0.9.0;
import "./Smart_Binance_Pro.sol";
contract Smart_Binance_Pro_2 is Context{using SafeERC20 for IERC20; struct Node { uint32 id; uint32 AL; uint32 AR; uint24 LT; uint24 RT; uint8 XI; uint8 WN; bool YY; address UP; address PO; address QO; } mapping(address => Node) internal KW; mapping(address => uint8) internal EE; mapping(uint32 => address) internal VV; mapping(uint32 => uint32) internal QF; mapping(uint32 => uint32) internal QL; mapping(uint32 => uint32) internal QL2; mapping(uint256 => address) internal JJ; mapping(uint24 => address) internal JL; mapping(uint24 => address) internal JO; mapping(uint16 => address) internal LM; mapping(uint16 => address) internal QZ14; address internal GOD; address internal SBT2; address internal OP; address internal JY; address internal SV; IERC20 internal Tether; uint32 internal JK; uint24 internal DJ; uint24 internal DW; uint24 internal ZL; uint16 internal DS; uint16 internal QZ13; uint256 internal ZS; uint256 internal ZM; uint256 internal DZ; uint256 internal QZ7; bool internal LK; bool internal Set_Bank; Smart_Binance_Pro internal NBJ; string internal IPFS;
    constructor(){ GOD = _msgSender();
        Tether = IERC20(0x55d398326f99059fF775485246999027B3197955);
        SBT2 = 0x790389f976DD0f5C81592DB3020d136929dcf7c5;
        SV = 0x07418EC67B00D0B3f7a69f0984BB145FC29c85e0;
        OP = 0x29cDA5EB13a774f7D1102A4B04D987E5A246ee47;
        NBJ = Smart_Binance_Pro(0xFc46B09bf98858B08C5c5DEeb5c19E609FaBD398);
        VV[JK] = 0x00e21f2B131CD5ba0c2e5594B1a7302A6Aa64152; JK++; Node memory A = Node({id: 661, AL: 10300, AR: 0,LT: 10300,RT: 0, XI: 2, WN : 0 , YY: false, UP: address(0), PO: 0xf77aF59DFF41226E2c71eE3ea947227D296985d6, QO: address(0)}); KW[0x00e21f2B131CD5ba0c2e5594B1a7302A6Aa64152] = A; ZS = block.timestamp;}
    function Register(address Up) external {DC(Up);} function DC(address Up) private {
        require(LK == false, " Processing ");
        require(KW[Up].XI != 2, " Upline Has 2 directs ");
        require(_msgSender() != Up, " Dont enter your address " );
        require(!DX(_msgSender()), " You Are registered ");
        require(DX(Up), " Upline is Not Exist "); LK = true; Tether.safeTransferFrom(_msgSender(), address(this), 100 * 10**18); VV[JK] = _msgSender(); JK++; Node memory user = Node({ id: JK, AL: 0, AR: 0, LT: 0, RT: 0, XI: 0, WN:0 , YY: KW[Up].XI == 0 ? false : true, UP: Up, PO: address(0), QO: address(0) }); KW[_msgSender()] = user;  JJ[DZ] = _msgSender(); DZ++; if (KW[Up].XI == 0) {KW[Up].LT++; KW[Up].AL++; KW[Up].PO = _msgSender();} else {KW[Up].RT++; KW[Up].AR++; KW[Up].QO = _msgSender();} KW[Up].XI++; LK = false;}
    function Reward_4() external {DH();} function DH() private {
        require(LK == false, " Processing ");
        require(DX(_msgSender()),"User Is Not Exist");
        require(block.timestamp > ZS + 4 hours, " Reward_4 Time Has Not Come "); ZB(); require(ZI() > 0, " Total Point Is 0 "); LK = true ; ZL = ZI(); JY = _msgSender(); uint256 ZO = ZK(); ZM = ZO; uint256 D_T = (DZ * QZ7 * 10**18 ); for (uint24 i = 0; i < DJ; i++) { Node memory ZN = KW[JL[i]]; uint24 UT = ZH(JL[i]); if (ZN.LT == UT) {ZN.LT = 0; ZN.RT -= UT;} else if (ZN.RT == UT) {ZN.LT -= UT; ZN.RT = 0;} else { if (ZN.LT < ZN.RT) {ZN.RT -= ZN.LT; ZN.LT = 0;} else {ZN.LT -= ZN.RT; ZN.RT = 0;}}  KW[JL[i]] = ZN; if (User_All_Point(JL[i]) < 100) { if (UT * ZO > Tether.balanceOf(address(this))) { Tether.safeTransfer(JL[i], Tether.balanceOf(address(this))); } else { Tether.safeTransfer(JL[i], UT * ZO); }} else { if (((UT * ZO * 9) / 10) > Tether.balanceOf(address(this))) {Tether.safeTransfer(JL[i], Tether.balanceOf(address(this))); } else { Tether.safeTransfer(JL[i], ((UT * ZO * 9) / 10)); } } } if (D_T <= Tether.balanceOf(address(this))) {Tether.safeTransfer(_msgSender(), D_T);} Tether.safeTransfer(SV, Tether.balanceOf(address(this)));  ZS = block.timestamp; DZ = 0; DJ = 0; DW = 0; DS = 0; LK = false ;}
    function ZB() private {address ZC; address ZD; for (uint256 k = 0; k < DZ; k++) {ZC = KW[KW[JJ[k]].UP] .UP; ZD = KW[JJ[k]].UP; if (ZE(ZD) == true) { JL[DJ] = ZD; DJ++; } while (ZC != address(0)) { if (KW[ZD].YY == false) { KW[ZC].LT++; KW[ZC].AL++;} else { KW[ZC].RT++; KW[ZC].AR++;} if (ZE(ZC) == true) { JL[DJ] = ZC; DJ++;} ZD = ZC; ZC = KW[ZC].UP;}}}
    function Smart_Gift(uint8 X) external {
        require(LK == false , "Processing");
        require(X < 6 && X > 0, " Just : 1,2,3,4,5 " );
        require(DX(_msgSender()), " User is Not Exist ");
        require(User_All_Point(_msgSender()) < 1, " Just All Time 0 Point ");
        require(Just_Gift_Balance() > 4, " Smart_Gift Balance Is 0 ");
        require(KW[_msgSender()].WN < 31, "You Did Win 30 Times");
        require(User_Big_Side(_msgSender()) < 31, " Just Big Side < 30 ");
        require(ZF(_msgSender()), " You Did Smart_Gift Today "); LK = true ; JO[DW] = _msgSender(); DW++; if (X == random(4)) {Tether.safeTransfer(_msgSender(), 5 * 10**18); LM[DS] = _msgSender(); KW[_msgSender()].WN++; DS++;} LK = false ;}
    function Smart_Import(address User) external {
        require(NBJ.User_Info(User).UP != address(0), "User Is Not Exist In Smart Binance Pro" );
        require(DX(NBJ.User_Info(User).UP) , "UPline Is Not Imported" );
        require(!DX(User), " You Are Imported "); VV[JK] = User; JK++; Node memory user = Node({ id: uint32(NBJ.User_Info(User).id), AL: uint32(NBJ.User_Info(User).AL), AR: uint32(NBJ.User_Info(User).AR), LT: uint24(NBJ.User_Info(User).LT), RT: uint24(NBJ.User_Info(User).RT), XI: uint8(NBJ.User_Info(User).XI), WN : 0 ,  YY: NBJ.User_Info(User).YY , UP: NBJ.User_Info(User).UP, PO: NBJ.User_Info(User).PO, QO: NBJ.User_Info(User).QO }); KW[User] = user; }
    function Smart_Buy_Over() public {
        require(LK == false, "Processing");
        require(DX(_msgSender()), "User Is Not Exist");
        require(QL[KW[_msgSender()].id] < 1, "Just 1 Time");
        require(User_All_Point(_msgSender()) > 2, "Just Point > 3");
        require(Tether.balanceOf(_msgSender()) >= (30 * 10**18),"You Dont Have Enough Tether!"); LK = true; Tether.safeTransferFrom(_msgSender(), address(this), 30 * 10**18); Tether.safeTransfer(SV, 20 * 10**18); if (KW[GOD].LT > 15) { KW[GOD].LT -= 3; KW[GOD].AL -= 3; } else if (KW[KW[GOD].PO].LT > 15) { KW[KW[GOD].PO].LT -= 3; KW[KW[GOD].PO].AL -= 3;} else if (KW[KW[KW[GOD].PO].PO].LT > 15) { KW[KW[KW[GOD].PO].PO].LT -= 3; KW[KW[KW[GOD].PO].PO].AL -= 3;} if (KW[_msgSender()].LT > KW[_msgSender()].RT) { KW[_msgSender()].LT += 3; KW[_msgSender()].AL += 3; } else {KW[_msgSender()].RT += 3; KW[_msgSender()].AR += 3;}  QL[KW[_msgSender()].id]++; LK = false;}
    function _Dont_Change_Address() external {
        require(DX(_msgSender()), "User Is Not Exist" );
        require(QK(_msgSender()), "You Did Before"); QZ14[QZ13] = _msgSender(); QZ13++; }
    function _Change_Address(address X ) external {
        require(LK == false, "Processing");
        require(IRT(_msgSender()),"User Is Registered Today, Try After Reward_4");
        require(QL2[KW[_msgSender()].id] < 2 , "Just 2 Times");
        require(X!= address(0), "Dont Enter address 0");
        require(DX(_msgSender()),"User Is Not Exist");
        require(!DX(X), "New Address Is Exist!");
        require(QK(_msgSender()),"New Address Is In: Dont_Change_Address!"); LK = true; Node memory A = KW[_msgSender()]; VV[A.id] = X; Node memory B = KW[A.PO]; B.UP = X; KW[A.PO] = B; Node memory C = KW[A.QO]; C.UP = X; KW[A.QO] = C; Node memory U = KW[A.UP]; if (A.YY == false) {U.PO = X ;} else {U.QO = X;} KW[A.UP] = U; KW[X] = A; delete KW[_msgSender()]; QL2[KW[_msgSender()].id]++; LK = false;}
    function Smart_Air_Drop() external { 
        require(DX(_msgSender()), "User Is Not Exist");
        require(QF[KW[_msgSender()].id] < 2, "Just 2 Times"); uint32 K = User_All_Point(_msgSender()); if(K >= 0 && K < 1000) {IERC20(SBT2).transfer(_msgSender(), 100 * 10**18); QF[KW[_msgSender()].id]++;} else if(K >= 1000 && K < 10000) {IERC20(SBT2).transfer(_msgSender(), 1000 * 10**18); QF[KW[_msgSender()].id]++;} else if(K >= 10000) {IERC20(SBT2).transfer(_msgSender(), 10000 * 10**18); QF[KW[_msgSender()].id]++;}}
    function _2_Days_Buy_Back() external {require(block.timestamp > ZS + 48 hours,"_2_Days_Buy_Back Time Has Not Come" ); uint256 P = 90 * 10**18; for (uint24 i = 0; i < DZ; i++) { if (P <= Tether.balanceOf(address(this))) {Tether.safeTransfer(JJ[i], P);}} Tether.safeTransfer(GOD, Tether.balanceOf(address(this))); IERC20(SBT2).safeTransfer(GOD, IERC20(SBT2).balanceOf(address(this))); ZS = block.timestamp; DZ = 0; DJ = 0; DW = 0; DS = 0; LK = false; }
    function ZK() private view returns (uint256) {return (DZ * 90 * 10**18) / ZI();}
    function random(uint256 number) private view returns (uint256) {return (uint256 (keccak256( abi.encodePacked(block.timestamp, block.prevrandao, msg.sender ) ) ) % number) + 1;}
    function DX(address A) private view returns (bool) {return (KW[A].id != 0);}
    function ZE(address A) private view returns (bool) { if (ZH(A) > 0) { for (uint24 i = 0; i < DJ; i++) { if (JL[i] == A) {return false;}} return true;} else {return false;}}
    function ZF(address A) private view returns (bool) { for (uint24 i = 0; i < DW; i++) { if (JO[i] == A) {return false;}} return true;}
    function unsafe_inc(uint24 x) private pure returns (uint24) {unchecked {return x + 1;}}
    function ZH(address A) private view returns (uint24) {uint24 min = KW[A].LT <= KW[A].RT ? KW[A].LT : KW[A].RT; if (min > 10) {return 10;} else {return min;}}
    function ZI() private view returns (uint24) { uint24 AA; for (uint24 i = 0; i <= DJ; i = unsafe_inc(i)) { uint24 min = KW[JL[i]].LT <= KW[JL[i]].RT ? KW[JL[i]].LT : KW[JL[i]].RT; if (min > 10) {min = 10;} AA += min;} return AA;}
    function _SBT2_() public view returns (address) {return SBT2;}
    function _Set_S_Coin(uint8 A) external { require(_msgSender() == OP, "Just Operator");  require(A >= 0 && A < 3, "Just 1-2-3"); address[3] memory C = [ 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d, 0x1AF3F329e8BE154074D8769D1FFa4eE058B1DBc3, 0x40af3827F39D0EAcBF4A168f8D4ee67c121D11c9 ]; Tether = IERC20(C[A]); }
    function _Set_Smart_Bank(address X) external { require(_msgSender() == OP, "Just Operator"); require(Set_Bank == false, "Just 1 Time"); SV = X; Set_Bank = true; }
    function _Write_IPFS(string memory I) public {require(_msgSender() == OP , " Just operator "); IPFS = I;}
    function _Reward_Fee_Set() external view returns (uint256) {return QZ7;}   
    function _IPFS_() public view returns (string memory) {return IPFS;}
    function Add_Approve_S_Coin() external view returns (address) { return address(Tether); }
    function All_Register() public view returns (uint32) {return JK;}
    function All_Contract_Payment() public view returns (uint32) {return JK * 100 ;}
    function All_User_Address(uint32 start, uint32 end) public view returns (address[] memory) { uint32 index; address[] memory ret = new address[]((end - start) + 1); for (uint32 i = start; i <= end; i++) { ret[index] = VV[i]; index++;  } return ret;  }
    function Last_Value_Point() public view returns (uint256) {return ZM / 10**18; }
    function Last_Reward_4_Writer() public view returns(address) {return JY;}
    function Last_Total_Point() public view returns (uint24) {return ZL;}
    function Just_Contract_Balance() public view returns (uint256) {return Tether.balanceOf(address(this)) / 10**18;}
    function Just_Gift_Balance() public view returns (uint256) {return (Just_Contract_Balance() - (DZ * 95));}
    function Today_Contract_InPut() public view returns (uint256) {return (DZ * 100);}
    function Today_Register_Address() public view returns (address[] memory) {address[] memory ret = new address[](DZ); for (uint24 i = 0; i < DZ; i++) {ret[i] = JJ[i];} return ret;}
    function Today_Gift_Winner_Address() public view returns(address[] memory) {address[] memory ret = new address[](DS); for (uint16 i = 0; i < DS; i++) {ret[i] = LM[i];} return ret;}
    function Today_Register_Number() public view returns (uint256) {return DZ; }
    function Today_Reward_4_Fee() public view returns (uint256) {return DZ * QZ7;}
    function User_Upline(address X) public view returns (address) {return KW[X].UP;}
    function User_Gift_Win(address A) public view returns (uint8) {return KW[A].WN;}
    function QK(address A) private view returns (bool) {for (uint8 i = 0; i < QZ13; i++) {if (QZ14[i] == A) { return false;}} return true; }
    function IRT(address A) private view returns (bool) {for (uint256 i = 0; i < DZ; i++) {if (JJ[i] == A) { return false; } } return true; }
    function User_Directs(address X) public view returns (address, address) {return (KW[X].PO, KW[X].QO );}
    function User_All_Left_Right (address X) public view returns (uint32, uint32) {return (KW[X].AL, KW[X].AR);}
    function User_All_Team (address X) public view returns (uint32) {return (KW[X].AL + KW[X].AR);}
    function User_Over_Left_Right (address X) public view returns (uint32, uint32) {return (KW[X].LT, KW[X].RT);}
    function User_Big_Side(address X) public view returns (uint32) {return KW[X].AL >= KW[X].AR ? KW[X].AL : KW[X].AR; }
    function User_All_Point(address X) public view returns (uint32) {return KW[X].AL <= KW[X].AR ? KW[X].AL : KW[X].AR; }
    function User_Info(address X) public view returns (Node memory) {return KW[X];}
    function _Smart_Binance_pro_() external pure returns (address) { return 0xFc46B09bf98858B08C5c5DEeb5c19E609FaBD398;}
    function _Smart_Bank_() external view returns (address) {return SV;}
    function Today_Gift_Candida_Address() public view returns (address[] memory) {address[] memory ret = new address[](DW); for (uint24 i = 0; i < DW; i++) {ret[i] = JO[i];} return ret;}
    function _Set_Reward_Fee(uint256 X) external { require(_msgSender() == OP, "Just Operator");  require(X <= 5 && X > 0, "Just 1-5"); QZ7 = X; } 
    function User_Is_My_Line(address Up_Line, address Down_Line) external view returns (string memory){ address E= KW[Down_Line].UP; bool temp; while (E != address(0)) {if (E== Up_Line){temp = true; break;} E= KW[E].UP;}if (temp){return "YES!";} else {return "NO!";}}}