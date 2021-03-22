pragma solidity ^0.4.19;

// put import statement here
import "./zombiefactory.sol";

// สร้าง KittyInterface ตรงนี้
contract KittyInterface {
    function getKitty(uint256 _id) external view returns (
        bool isGestating,
        bool isReady,
        uint256 cooldownIndex,
        uint256 nextActionAt,
        uint256 siringWithId,
        uint256 birthTime,
        uint256 matronId,
        uint256 sireId,
        uint256 generation,
        uint256 genes
    );
}

contract ZombieFeeding is ZombieFactory {

    address ckAddress = 0x06012c8cf97BEaD5deAe237070F9587f8E7A266d;
    // Initialize kittyContract here using `ckAddress` from above
    KittyInterface kittyContract = KittyInterface(ckAddress);

    // เริ่มที่ตรงนี้
    // Modify function definition here:
    function feedAndMultiply(uint _zombieId, uint _targetDna, string _species) public {
        require(msg.sender == zombieToOwner[_zombieId]);
        Zombie storage myZombie = zombies[_zombieId];
        // start here
        _targetDna = _targetDna % dnaModulus;
        uint newDna = (myZombie.dna + _targetDna) / 2;
        // ใส่ if statement ได้ตรงนี้
        if (keccak256(_species) == keccak256("kitty")) {
            newDna = newDna - newDna % 100 + 99;
        }
        _createZombie("NoName", newDna);
    } 

    // กำหนดฟังก์ชั่นไว้ตรงนี้
    function feedOnKitty(uint _zombieId, uint _kittyId) public {
      uint kittyDna;
      (,,,,,,,,,kittyDna) = kittyContract.getKitty(_kittyId);
      // And modify function call here:
      feedAndMultiply(_zombieId, kittyDna, "kitty");
    }

}


https://share.cryptozombies.io/th/lesson/2/share/kazuoka



/*


ในตอนนี้หลังจากได้ตั้งค่าโครงสร้างหลายไฟล์ขึ้นมา (multi-file structure) เราจำเป็นจะต้องใช้คำสั่ง import เพื่ออ่านเนื้อหาของอีกไฟล์หนึ่งด้วย:

อิมพอร์ต zombiefactory.sol เข้าไปในไฟล์ใหม่ที่ชื่อว่า zombiefeeding.sol



ถึงเวลาแล้วที่จะมอบความสามารถให้ซอมบี้ของเรานั้นกินได้หลาย ๆ อย่าง!

เมื่อใดที่ซอมบี้กินสิ่งมีชีวิตเข้าไป DNA ของมันจะไปรวมกับ DNA ของเหยื่อดังกล่าวและผลิตซอมบี้ตัวใหม่ขึ้นมา

สร้างฟังก์ชั่นที่มีชื่อว่า feedAndMultiply ให้รับ parameter 2 ค่า: _zombieId (ชนิด uint) และ _targetDna (ชนิด uint) ฟังก์ชั่นนี้ควรมีค่าเป็น public.

แต่เราไม่ต้องการให้ผู้อื่นมาให้อาหารซอมบี้ของเรา! ดังนั้นในอันดับแรก ต้องทำให้แน่ใจว่าซอมบี้นี้เป็นของเราเสียก่อน โดยใส่คำสั่ง require เพื่อให้มั่นใจว่า msg.sender คือเจ้าของของซอมบี้ (คล้ายกับตอนที่ทำในฟังก์ชั่น createRandomZombie).

Note: answer-checker ของเราค่อนข้างล้าหลัง จึงควรให้ msg.sender มาก่อน ไม่เช่นนั้นคำตอบจะถือว่าผิด แต่ในความเป็นจริงจะเอาอะไรขึ้นก่อนก็ไม่มีปัญหาแน่นอน

เราจำเป็นต้องมี DNA ของซอมบี้ เพราะฉะนั้น สิ่งที่ฟังก์ชั่นของเราต้องทำต่อไปก็คือการประกาศ local Zombie ที่มีชื่อว่า myZombie (ซึ่งจะเป็น pointer ของ storage ) ตั้งค่าตัวแปรนี้ให้เท่ากับ index _zombieId ใน array ชื่อ zombies

ณ ตอนนี้โค้ดควรมีความยาว 4 บรรทัด โดยนับรวมแท็กปิด }แล้ว

เราจะมาสร้างฟังก์ชั่นนี้ต่อในบทถัดไป




อันดับแรกต้องมั่นใจว่า _targetDna มีความยาวไม่เกิน 16 ตัว ในการทำเช่นนั้น สามารถตั้งค่า _targetDna ให้เท่ากับ _targetDna % dnaModulus เพื่อให้รับ input ที่มีความยาวไม่เกิน 16 ตัว

ต่อมาฟังก์ชั่นของเราควรประกาศข้อมูลชนิด uint ที่มีชื่อว่า newDnaและ set ให้เท่ากับค่าเฉลี่ยระหว่าง DNA ของ myZombie และ _targetDna (เหมือนในตัวอย่างทางด้านบน)

Note: สามารถเข้าถึง property ของ myZombie โดยการใช้ myZombie.name และ myZombie.dna

เมื่อได้ DNA ใหม่ขึ้นมาแล้ว ก็ถึงเวลาของการเรียกฟังก์ชั่น _createZombie โดยสามารถเข้าไปดูได้ที่ tab zombiefactory.sol หากลืมว่าฟังก์ชั่นนี้ต้องเรียก parameter ตัวใดบ้าง อย่าลืมว่าเราต้องการชื่อของซอมบี้อีกด้วย ดังนั้นให้ตั้งชื่อว่า "NoName" ไปก่อน — สามารถมาเขียนฟังก์ชั่นสำหรับการเปลี่ยนชื่อซอมบี้ในภายหลังได้

Note: ผู้ที่เชี่ยวชาญ Solidity บางท่านอาจสังเกตเห็นปัญหาของโค้ดตรงส่วนนี้ ! อย่ากังวลไป เพราะเราจะเข้ามาแก้ไขแน่นอนในบทถัดไป ;)





หลังจากได้เข้าไปดู source code ของ CryptoKitties เรียบร้อย และพบฟังก์ชั่นที่เรียกว่า getKitty ซึ่งจะรีเทิร์นข้อมูลของน้องแมวทั้งหมดออกมา ประกอบไปด้วยยีนส์ ("genes") ของมัน (เกมซอมบี้ของเราต้องการสิ่งนี้ในการสร้างซอมบี้ตัวใหม่นั้นเอง!).

The function looks like this:

function getKitty(uint256 _id) external view returns (
    bool isGestating,
    bool isReady,
    uint256 cooldownIndex,
    uint256 nextActionAt,
    uint256 siringWithId,
    uint256 birthTime,
    uint256 matronId,
    uint256 sireId,
    uint256 generation,
    uint256 genes
) {
    Kitty storage kit = kitties[_id];

    // if this variable is 0 then it's not gestating
    isGestating = (kit.siringWithId != 0);
    isReady = (kit.cooldownEndBlock <= block.number);
    cooldownIndex = uint256(kit.cooldownIndex);
    nextActionAt = uint256(kit.cooldownEndBlock);
    siringWithId = uint256(kit.siringWithId);
    birthTime = uint256(kit.birthTime);
    matronId = uint256(kit.matronId);
    sireId = uint256(kit.sireId);
    generation = uint256(kit.generation);
    genes = kit.genes;
}
ฟังก์ชั่นจะมีความแตกต่างเล็กน้อยจากฟังก์ชั่นปกติที่เราใช้กัน สามารถเห็นได้จากการรีเทิร์น... ค่าที่แตกต่างกันไปจำนวนหนึ่ง หากคุณมีความรู้มาจากภาษา Javascript สิ่งนี้จะค่อนข้างแตกต่าง ใน Solidity เราสามารถรีเทิร์นผลลัพธ์ออกมาจากฟังก์ชั่นได้หลายค่า

ตอนนี้เราก็ทราบแล้วว่าฟังก์ชั่นหน้าตาเป็นอย่างไร ทำให้สามารถใช้ในการสร้าง interface ขึ้นมาได้:

กำหนด interface ที่มีชื่อว่า KittyInterface จงจำไว้ว่ามันก็เหมือนกับการสร้าง contract ขึ้นมาใหม่ — เราใช้ keyword คำว่า contract

ภายใน interface กำหนดฟังก์ชั่นชื่อว่า getKitty (สามารถ copy/paste มาจากฟังก์ชั่นด้านบนได้เลย แต่เปลี่ยนเป็นเครื่องหมาย semi-colon หลังจากคำว่า returns ด้วยแทนที่จะเป็น { และ }




มาสร้าง contract ที่เอาไว้อ่าน smart contract ของน้องแมว CryptoKitties กันดีกว่า!

เราได้บันทึก address ที่เป็นของ contract ชื่อว่า CryptoKitties ไว้ให้แล้ว โดยจะอยู่ในส่วนของตัวแปรที่ชื่อ ckAddress ในโค้ดบรรทัดต่อไป ให้สร้าง KittyInterface ที่มีชื่อว่า kittyContract และตั้งค่าเริ่มต้นของ interface นี้โดยใช้ ckAddress — ทำแบบเดียวกันกับใน numberContract ที่แสดงไว้ข้างต้น




มาถึงช่วงของการ interact กับ contract ชื่อ CryptoKitties แล้ว!

การสร้างฟังก์ชั่นที่จะรับ kitty genes มาจาก contract:

สร้างฟังก์ชั่นที่มีชื่อว่า feedOnKitty โดยฟังก์ชั่นนี้จะรับข้อมูลชนิด uint 2 พารามิเตอร์ ได้แก่ _zombieId และ _kittyId โดยฟังก์ชั่นนี้ควรมีค่าเป็น public

โดยแต่แรกนั้นฟังก์ชั่นควรมีการประกาศตัวแปรชนิด uint ชื่อว่า kittyDna.

Note: ใน KittyInterface ตัวแปร genes มีชนิดเป็น uint256 — แต่หากเรายังไม่ลืมบทเรียนแรกจะจำได้ว่า uint ไม่ได้ต่างจาก uint256 — เรียกว่าเหมือนกันเลยก็ว่าได้

ฟังก์ชั่นนี้จะต้องสามารถเรียกฟังก์ชั่นที่ชื่อว่า kittyContract.getKitty โดยใช้ _kittyId และเก็บค่า genes ให้อยู่ไว้ใน kittyDna อย่าลืมว่า — getKitty จะรีเทิร์นตัวแปรออกมาหลายค่า (ก็คือ 10 ตัวนั่นเอง — จริงๆ เราแอบนับให้เรียบร้อยแล้ว!) แต่ตัวแปรสุดท้ายจะเป็นตัวที่เราสนใจจริงๆ ซึ่งก็คือ genes นับ comma ให้ดีๆ ด้วยนะ!

ท้ายที่สุดแล้วฟังก์ชั่นนี้ควรสามารถเรียก feedAndMultiply โดยรับค่า _zombieId และ kittyDnaได้




ก่อนอื่นให้เปลี่ยน definition ของฟังก์ชั่น feedAndMultiply ให้สามารถรับ argument ที่ 3 ได้: ข้อมูลชนิด string ที่มีชื่อว่า _species

ต่อมาหลังจากเราได้คำนวณ DNA ของซอมบี้แล้ว ก็คือเวลาของการเพิ่มเงื่อนไข if เพื่อการเปรียบเทียบ keccak256 hashes ระหว่าง _species และข้อมูล string ชื่อว่า"kitty"

ภายใต้เงื่อนไข if เราต้องแทนที่รหัส DNA 2 ตัวสุดท้ายด้วย 99ในการที่จะทำได้เราต้องใช้ logic ดังนี้: newDna = newDna - newDna % 100 + 99;.

Explanation: สมมติให้ newDna เป็น 334455 ดังนั้น newDna % 100 มีค่าเท่ากับ 55 ซึ่งทำให้ newDna - newDna % 100 มีค่า 334400 สุดท้ายเพิ่ม 99 ลงไปที่ตำแหน่ง 2 ตัวสุดท้าย จะกลายเป็น 334499.

ท้ายที่สุดแล้วเราจะต้องเปลี่ยนฟังก์ชั่นที่เรียกภายใน feedOnKitty เมื่อมีการเรียกฟังก์ชั่น feedAndMultiplyให้เพิ่มตัวแปรชื่อว่า "kitty" เข้าไปเป็นตอนสุดท้าย







*/