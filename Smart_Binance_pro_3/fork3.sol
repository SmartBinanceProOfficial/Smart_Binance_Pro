// SPDX-License-Identifier: Unlicensed
pragma solidity >=0.4.22 <0.9.0;
import "./Smart_Binance_Pro_2.sol";
contract Smart_Binance_Pro_3 is Context{using SafeERC20 for IERC20; 
struct Node { uint32 id; uint32 AL; uint32 AR; uint24 LT; uint24 RT; uint8 XI; bool YY; bool FF; address UP; address PO; address QO;} 
mapping(address => Node) internal KW; mapping(address => uint8) internal EE; mapping(uint32 => address) internal VV; mapping(uint32 => uint32) internal QF; 
mapping(uint32 => uint32) internal QL; mapping(uint32 => uint32) internal QL2; mapping(uint32 => uint32) internal QL3; mapping(uint256 => address) internal JJ; 
mapping(uint24 => address) internal JL; mapping(uint16 => address) internal QZ14; mapping(address => uint256) internal CA; address internal GOD; address internal SBT3; address internal JY; address internal SV; address internal OP;
IERC20 internal Tether; uint32 internal JK; uint24 internal DJ; uint24 internal ZL; uint16 internal QZ13; uint256 internal ZS; uint256 internal ZM; uint256 internal DZ; 
uint256 internal LZ; uint256 internal QZ7; uint256 internal QZ8; bool internal LK; bool internal MJ; bool internal Set_Bank; Smart_Binance_Pro_2 internal NBJ; string internal IPFS;
    constructor(){ GOD = _msgSender();
        Tether = IERC20(0x55d398326f99059fF775485246999027B3197955);
        SBT3 = 0x959Fb5c95877c66F18B4Bccb56ca1e5C3DFB5244;
        SV = 0x07418EC67B00D0B3f7a69f0984BB145FC29c85e0;
        OP = 0x0C18f53831Ad07e24987F02afd40cf3cF2423350;
        NBJ = Smart_Binance_Pro_2(0x8E60F00C14D5BB0B183a8e0a0e97737D254d906e);
        VV[JK] = 0x00e21f2B131CD5ba0c2e5594B1a7302A6Aa64152; JK++; Node memory A = Node({id: JK, AL: 17800, AR: 0,LT: 17800,RT: 0, XI: 1, YY: false, FF: false, UP: address(0), PO: 0xf77aF59DFF41226E2c71eE3ea947227D296985d6, QO: address(0)}); KW[0x00e21f2B131CD5ba0c2e5594B1a7302A6Aa64152] = A; ZS = block.timestamp;}
    function Register(address Up) external {DC(Up);} function DC(address Up) private {
        require(I_C(_msgSender()) == false, "Just Wallet");
        require(KW[Up].XI != 2, " Upline Has 2 Directs ");
        require(_msgSender() != Up, " Dont Enter Your Address " );
        require(!DX(_msgSender()), " You Are Registered ");
        require(DX(Up), " Upline Not Exist "); 
        require(LK == false, " Processing "); LK = true; Tether.safeTransferFrom(_msgSender(), address(this), 100 * 10**18); VV[JK] = _msgSender(); JK++; Node memory user = Node({ id: JK, AL: 0, AR: 0, LT: 0, RT: 0, XI: 0 , YY: KW[Up].XI == 0 ? false : true, FF: false, UP: Up, PO: address(0), QO: address(0)}); KW[_msgSender()] = user; JJ[DZ] = _msgSender(); DZ++; if (KW[Up].XI == 0) {KW[Up].LT++; KW[Up].AL++; KW[Up].PO = _msgSender();} else {KW[Up].RT++; KW[Up].AR++; KW[Up].QO = _msgSender();} KW[Up].XI++; LK = false;}
    function Max_Point() external {DC2();} function DC2() private {
        require(I_C(_msgSender()) == false, "Just Wallet");
        require(KW[_msgSender()].FF == false, "You Did Max_Point");
        require(DX(_msgSender()),"User Not Exist");
        require(LK == false, " Processing "); LK = true; Tether.safeTransferFrom(_msgSender(), address(this), 200 * 10**18); KW[_msgSender()].FF = true; JJ[DZ] = _msgSender(); DZ++; LZ++; if (KW[_msgSender()].YY == false) {KW[KW[_msgSender()].UP].LT++; KW[KW[_msgSender()].UP].AL++; } else {KW[KW[_msgSender()].UP].RT++; KW[KW[_msgSender()].UP].AR++;} LK = false; }
    function Reward() external {DH();} function DH() private {
        require(I_C(_msgSender()) == false, "Just Wallet");
        require(DX(_msgSender()),"User Not Exist");
        require(User_All_Point(_msgSender()) > 0, "You Have No Point");
        if (QZ8 == 1) {require(block.timestamp > ZS + 1 hours, " Reward Time Has Not Come ");
        }else{require(block.timestamp > ZS + 2 hours, " Reward Time Has Not Come "); }
        ZB(); require(ZI() > 0, " Total Point Is 0 ");
        require(LK == false, " Processing "); LK = true ; ZL = ZI(); JY = _msgSender(); uint256 ZO = ZK(); ZM = ZO; uint256 D_T = ((DZ-LZ) * QZ7 * 10**18 ); for (uint24 i = 0; i < DJ; i++) { Node memory ZN = KW[JL[i]]; uint24 UT = ZH(JL[i]); if (ZN.LT == UT) {ZN.LT = 0; ZN.RT -= UT;} else if (ZN.RT == UT) {ZN.LT -= UT; ZN.RT = 0;} else { if (ZN.LT < ZN.RT) {ZN.RT -= ZN.LT; ZN.LT = 0;} else {ZN.LT -= ZN.RT; ZN.RT = 0;}}  KW[JL[i]] = ZN; if (User_All_Point(JL[i]) < 100) { if (UT * ZO > Tether.balanceOf(address(this))) { Tether.safeTransfer(JL[i], Tether.balanceOf(address(this))); } else { Tether.safeTransfer(JL[i], UT * ZO); }} else { if (((UT * ZO * 9) / 10) > Tether.balanceOf(address(this))) {Tether.safeTransfer(JL[i], Tether.balanceOf(address(this))); } else { Tether.safeTransfer(JL[i], ((UT * ZO * 9) / 10)); } } } if (D_T <= Tether.balanceOf(address(this))) {Tether.safeTransfer(_msgSender(), D_T);} Tether.safeTransfer(SV, Tether.balanceOf(address(this))); ZS = block.timestamp; DZ = 0; LZ = 0; DJ = 0; LK = false ;}
    function ZB() private {address ZC; address ZD; for (uint256 k = 0; k < DZ; k++) { ZC = KW[KW[JJ[k]].UP].UP; ZD = KW[JJ[k]].UP; if (ZE(ZD) == true) { JL[DJ] = ZD; DJ++;} while (ZC != address(0)) { if (KW[ZD].YY == false) { KW[ZC].LT++; KW[ZC].AL++;} else { KW[ZC].RT++; KW[ZC].AR++;} if (ZE(ZC) == true) {JL[DJ] = ZC; DJ++;} ZD = ZC; ZC = KW[ZC].UP;}}}
    function Smart_Gift(uint8 R) external {
        require(I_C(_msgSender()) == false, "Just Wallet");
        require(R < 4 && R > 0, " Just : 1,2,3 " );
        require(DX(_msgSender()), " User Not Exist ");
        require(User_All_Point(_msgSender()) < 1, "Maximum Left_Right : 9-0");
        require(Just_Gift_Balance() > 4, " Smart_Gift Balance Is 0 ");
        require(QL3[KW[_msgSender()].id] < 18, "Just 18 Times");
        require(User_Big_Side(_msgSender()) < 10, "Maximum Left_Right : 9-0"); if (R == random(3)) {Tether.safeTransfer(_msgSender(), 5 * 10**18); QL3[KW[_msgSender()].id]++; } }
    function random(uint256 number) private view returns (uint256) {return (uint256 (keccak256( abi.encodePacked(block.timestamp, block.prevrandao, msg.sender ) ) ) % number) + 1;}
    function _Import_Fast (uint24 start , uint24 end) external {
        require(_msgSender() == OP, "Just Operator");
        address[] memory ZA1 = NBJ.All_User_Address(start,end);
        address User; for (uint24 i = 0; i <= (end-start); i++) { User = ZA1[i]; if (CA[User] == 0) {
                VV[JK] = User; JK++; Node memory user = Node({ id: uint32(JK), AL: uint32(NBJ.User_Info(User).AL),
                AR: uint32(NBJ.User_Info(User).AR), LT: uint24(NBJ.User_Info(User).LT),
                RT: uint24(NBJ.User_Info(User).RT), XI: uint8(NBJ.User_Info(User).XI),
                YY: NBJ.User_Info(User).YY, FF:false , UP: NBJ.User_Info(User).UP,
                PO: NBJ.User_Info(User).PO, QO: NBJ.User_Info(User).QO });
                KW[User] = user; } } }
    function _Import_OPT(address User) external {require(_msgSender() == OP, "Just Operator");
        require(!DX(User), " You Are Imported "); VV[JK] = User; JK++; Node memory user = Node({ id: uint32(JK), AL: uint32(NBJ.User_Info(User).AL), AR: uint32(NBJ.User_Info(User).AR), LT: uint24(NBJ.User_Info(User).LT), RT: uint24(NBJ.User_Info(User).RT), XI: uint8(NBJ.User_Info(User).XI), YY: NBJ.User_Info(User).YY, FF:false , UP: NBJ.User_Info(User).UP, PO: NBJ.User_Info(User).PO, QO: NBJ.User_Info(User).QO }); KW[User] = user; }
    function _Dont_Change_My_Address() external {
        require(DX(_msgSender()), "User Not Exist" );
        require(QK(_msgSender()), "You Did Before"); QZ14[QZ13] = _msgSender(); QZ13++; }
    function _Change_My_Address(address X) external {
        require(I_C(_msgSender()) == false, "Just Wallet");
        require(((KW[_msgSender()].PO == address(0)) || (DX(KW[_msgSender()].PO) && (KW[_msgSender()].QO==address(0))) || (DX(KW[_msgSender()].PO) && DX(KW[_msgSender()].QO))) , "Your Directs Not Imported!" );
        require(IRT(_msgSender())," Do After Reward");
        require(QL2[KW[_msgSender()].id] < 3 , "Just 3 Times");
        require(X!= address(0), "Dont Enter address 0");
        require(DX(_msgSender()),"User Not Exist");
        require(!DX(X), "New Address Exist!");
        require(QK(_msgSender()),"New Address Is In: Dont_Change_My_Address!"); 
        require(LK == false, "Processing"); LK = true; Node memory A = KW[_msgSender()]; VV[A.id] = X; Node memory B = KW[A.PO]; B.UP = X; KW[A.PO] = B; Node memory C = KW[A.QO]; C.UP = X; KW[A.QO] = C; Node memory U = KW[A.UP]; if (A.YY == false) {U.PO = X ;} else {U.QO = X;} KW[A.UP] = U; KW[X] = A; delete KW[_msgSender()]; QL2[KW[_msgSender()].id]++; LK = false;}
    function _Add_Change_Address(address R) external{require(_msgSender() == OP, "Just Operator"); CA[R] = 1; }
    function Smart_Air_Drop() external { 
        require(I_C(_msgSender()) == false, "Just Wallet");
        require(DX(_msgSender()), "User Not Exist");
        require(QF[KW[_msgSender()].id] < 3, "Just 3 Times"); uint32 K = User_All_Point(_msgSender()); if(K >= 0 && K < 1000) {IERC20(SBT3).transfer(_msgSender(), 100 * 10**18); QF[KW[_msgSender()].id]++;} else if(K >= 1000 && K < 10000) {IERC20(SBT3).transfer(_msgSender(), 1000 * 10**18); QF[KW[_msgSender()].id]++;} else if(K >= 10000) {IERC20(SBT3).transfer(_msgSender(), 10000 * 10**18); QF[KW[_msgSender()].id]++;}}
    function _Bonus_For_100() external {require(_msgSender() == OP, "Just Operator"); for (uint32 i = 0; i < JK; i++) {if(User_All_Point(VV[i]) > 100) {IERC20(SBT3).transfer(_msgSender(), 100 * 10**18);}}}
    function _Buy_Back_12() external {require(I_C(_msgSender()) == false, "Just Wallet");
        require(block.timestamp > ZS + 12 hours,"_Buy_Back_12 Time Has Not Come" ); uint256 P = 90 * 10**18; for (uint24 i = 0; i < DZ; i++) { if (P <= Tether.balanceOf(address(this))) {Tether.safeTransfer(JJ[i], P);}} Tether.safeTransfer(GOD, Tether.balanceOf(address(this))); IERC20(SBT3).safeTransfer(GOD, IERC20(SBT3).balanceOf(address(this))); ZS = block.timestamp; DZ = 0; LZ = 0; DJ = 0; LK = false; }
    function _Set_Smart_Bank(address X) external {require(_msgSender() == OP, "Just Operator"); require(Set_Bank == false, "Just 1 Time"); SV = X; Set_Bank = true; }
    function ZK() private view returns (uint256) {return ((((DZ-LZ) * 90) + (LZ * 200)) * 10**18) / ZI();}
    function DX(address A) private view returns (bool) {return (KW[A].id != 0);}
    function ZE(address A) private view returns (bool) { if (ZH(A) > 0) { for (uint24 i = 0; i < DJ; i++) { if (JL[i] == A) {return false;}} return true;} else {return false;}}
    function ZH(address A) private view returns (uint24) {uint24 min = KW[A].LT <= KW[A].RT ? KW[A].LT : KW[A].RT; if (KW[A].FF == false){if (min > 5) {min = 5; }} else { if (min > 10) {min = 10;}} return min; }
    function ZI() private view returns (uint24) { uint24 AA; for (uint24 i = 0; i < DJ; i++) {AA += ZH(JL[i]);} return AA;}
    function _SBT3_() public view returns (address) {return SBT3;}
    function _Write_IPFS(string memory I) public {require(_msgSender() == OP , " Just operator "); IPFS = I;}
    function _Read_IPFS_() public view returns (string memory) {return IPFS;}
    function Add_Approve_USDT() external view returns (address) { return address(Tether); }
    function All_Register() public view returns (uint32) {return JK;}
    function All_User_Address(uint32 start, uint32 end) public view returns (address[] memory) { uint32 index; address[] memory ret = new address[]((end - start) + 1); for (uint32 i = start; i <= end; i++) { ret[index] = VV[i]; index++;  } return ret;  }
    function Last_Value_Point() public view returns (uint256) {return ZM / 10**18; }
    function Last_Reward_Writer() public view returns(address) {return JY;}
    function Last_Total_Point() public view returns (uint24) {return ZL;}
    function Just_Contract_Balance() public view returns (uint256) {return Tether.balanceOf(address(this)) / 10**18;}
    function Just_Gift_Balance() public view returns (uint256) {return (Just_Contract_Balance() - ((DZ-LZ) * 95) - (200 * LZ));}
    function QK(address A) private view returns (bool) {for (uint8 i = 0; i < QZ13; i++) {if (QZ14[i] == A) { return false;}} return true; }
    function IRT(address A) private view returns (bool) {for (uint256 i = 0; i < DZ; i++) {if (JJ[i] == A) { return false; } } return true; }
    function User_Big_Side(address R) private view returns (uint32) {return KW[R].AL >= KW[R].AR ? KW[R].AL : KW[R].AR; }
    function User_All_Point(address R) private view returns (uint32) {return KW[R].AL <= KW[R].AR ? KW[R].AL : KW[R].AR; }
    function User_Info(address R) public view returns (Node memory) {return KW[R];}
    function User_Upline(address R) public view returns (address) {return KW[R].UP;}
    function User_Directs(address R) public view returns (address, address) {return (KW[R].PO, KW[R].QO );}
    function User_All_Left_Right (address R) public view returns (uint32, uint32) {return (KW[R].AL, KW[R].AR);}
    function _Smart_Binance_pro_2() external pure returns (address) { return 0x8E60F00C14D5BB0B183a8e0a0e97737D254d906e;}
    function _Read_Smart_Bank_() external view returns (address) {return SV;}
    function _Set_Reward_Fee(uint256 R) external { require(_msgSender() == OP, "Just Operator"); 
    require(R <= 5 && R > 0, "Just 1-5"); QZ7 = R; } 
    function _Set_Reward_Time(uint256 R) external { require(_msgSender() == OP, "Just Operator"); 
    require(R <= 2 && R > 0, "Just 1-2"); QZ8 = R; } 
    function I_C(address R) private view returns (bool) {uint size; assembly { size := extcodesize(R) } return size > 0;}
    function User_Is_My_Line(address Up_Line, address Down_Line) external view returns (string memory){ address E= KW[Down_Line].UP; bool temp; while (E != address(0)) {if (E== Up_Line){temp = true; break;} E= KW[E].UP;}if (temp){return "YES!";} else {return "NO!";}}}