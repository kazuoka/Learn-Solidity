pragma solidity ^0.4.19;

contract ZombieFactory {

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    struct Zombie {
        string name;
        uint dna;
    }

    Zombie[] public zombies;

    // ประกาศ mapping ตรงนี้
    mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;


    // แก้ไขความหมายของฟังก์ชั่นได้ที่ด้านล่าง  เปลี่ยนจาก private เป็น internal
    function _createZombie(string _name, uint _dna) internal {
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // เริ่มตรงนี้
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender]++;
        NewZombie(id, _name, _dna);
    } 

    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        // เริ่มที่ตรงนี้
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }

}

// เริ่มที่ตรงนี้
contract ZombieFeeding is ZombieFactory {
    
}





/*

ในการเก็บค่าความเป็นเจ้าของแก่ซอมบี้ จะต้องใช้ mappings 2 อย่าง: อันแรกสำหรับการติดตามค่า address ที่จำเพาะต่อซอมบี้ และอันที่สองไว้ใช้ติดตามค่าจำนวนของซอมบี้ที่เจ้าของมี

สร้าง mapping ที่มีชื่อว่า zombieToOwnerซึ่งมี key เป็น uint (ซึ่งจะจัดเก็บและแสดงผลซอมบี้ขึ้นอยู่กับค่า id ของมัน) โดยจะมีค่าเป็นaddress เราจะทำให้ mapping นี้มีค่าการเข้าถึงเป็นชนิด public.

สร้าง mapping ที่มีชื่อว่า ownerZombieCount ซึ่งมี key เป็น address โดยจะมีค่าเป็น uint



มาทำการอัพเดท method _createZombie จากในบทที่ 1 เพื่อกำหนดค่าความเป็นเจ้าต่อผู้ใดก็ตามที่เรียกฟังก์ชั่นขึ้นมาให้กับซอมบี้นั้น ๆ

อันดับแรกหลังจากที่เราได้รับข้อมูล id ของซอมบี้เข้ามาแล้ว ก็จะถึงเวลาของการอัพเดท zombieToOwner ของเรา โดยทำการ map เพื่อเก็บ msg.sender ภายใต้ id นั้น

ขั้นตอนที่ 2 คือการเพิ่มจำนวน ownerZombieCount สำหรับ msg.sender

ใน Solidity จะเพิ่มค่า uint ด้วยเครื่องหมาย ++ เหมือนใน javascript:

uint number = 0;
number++;
// หลังบรรทัดนี้ `number` ถูกอัพเดทให้เป็น `1`
คำตอบสุดท้ายควรมีความยาว 2 บรรทัด



เกมซอมบี้ของเรานั้นไม่ต้องการให้ผู้ใช้สามารถสร้างซอมบี้ไปเรื่อย ๆ โดยไม่ที่สิ้นสุดจากการเรียกใช้ฟังก์ชั่น createRandomZombie ไปเรื่อย ๆ — เพราะจะทำให้เกมไม่สนุกแน่นอน

มาใช้คำสั่ง require เพื่อทำให้แน่ใจได้ว่าฟังก์ชั่นนี้จะถูกเรียกโดยผู้เล่น 1 คน เพียงแค่รอบเดียวในตอนที่เข้าเล่นเกมครั้งแรก

ใส่ statement require ที่ด้านหน้าของฟังก์ชั่น createRandomZombieโดยฟังก์ชั่นนี้จะต้องมีการตรวจสอบเพื่อความแน่ใจว่า ownerZombieCount[msg.sender] จะมีค่าเท่ากับ 0 และจะแสดง error หากไม่เป็นเช่นนั้น
Note: ใน Solidity จะไม่ให้ความสำคัญกับลำดับของคำสั่งว่าอะไรต้องมาก่อน อย่างไรก็ตาม โปรแกรมตรวจสอบความถูกต้องของเรานั้นค่อนข้างไม่ซับซ้อน จึงรับคำตอบที่ถูกต้องเพียงค่าเดียว ซึ่งก็คือต้องเอา ownerZombieCount[msg.sender] ขึ้นมานำหน้าก่อนเท่านั้น



ในบทถัดไปเราจะทำการเพิ่มคุณสมบัติของซอมบี้ให้มันสามารถกินได้หลายสิ่งมากขึ้น มาใส่ logic นี้ลงไปยัง class ที่มีการรับ inherit ทุก method มาจาก ZombieFactory

สร้าง contract ชื่อว่า ZombieFeeding ให้อยู่ด้านล่าง ZombieFactory โดย contract นี้จะต้องรับ inherit มาจาก contract ชื่อ ZombieFactory




เปลี่ยน _createZombie() จาก private ให้เป็น internal แทน เพื่อให้ contract อื่น ๆ ของเราสามารถเข้าถึงฟังก์ชั่นนี้ได้

ยังสามารถไปเปิด tab zombiefactory.solได้เหมือนเคย หากมีข้อสงสัย






*/