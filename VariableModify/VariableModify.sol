// SPDX-License-Identifier: GPL-3.0
// udayj

pragma solidity >=0.4.21 <0.9.0;

contract varmodify{
    uint16 public number = 0;


    function getnumber() public view returns (uint16) {

        return number;
    }

    function setnumber(uint16 value) public   {
        number = value;
    }

    function incrementnumber() public {
        number++;
    }
    function decrementnumber() public {
        if (number > 0)
            number--;
        
    }
}