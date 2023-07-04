// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

struct Car {
    uint256 id;
    uint256 price;
    string color;
    address owner;
}

contract Test {
    uint256 public totalCar;
    Car[] public cars;

    function createCar(Car[] memory _cars) public {
        for (uint256 i = 0; i < _cars.length; i++) { 
            cars.push(Car(_cars[i].id, _cars[i].price, _cars[i].color, _cars[i].owner));
            totalCar++;
        }
    }

    function getCar(uint256 _id) public view returns (Car memory) {
        require(_id < cars.length, "Car does not exist"); 
        return cars[_id];
    }

    function updateCar(uint256 _id, uint256 _price) public {
        require(_id < cars.length, "Car does not exist"); 
        cars[_id].price = _price;
    }

    function deleteCar(uint256 _id) public {
        require(_id < cars.length, "Car does not exist"); 
        delete cars[_id];
        totalCar--; 
    }

    function getCarLength() public view returns (uint256) {
        return cars.length;
    }

    function getCarOwner(uint256 _id) public view returns (address) {
        require(_id cars.length, "Car does not exist");
        return cars[_id].owner;
    }

    function getCarPrice(uint256 _id) public view returns (uint256) {
        require(_id cars.length, "Car does not exist");
        return cars[_id].price;
    }

    function getCarColor(uint256 _id) public view returns (string memory) {
        require(_id cars.length, "Car does not exist");
        return cars[_id].color;
    }

    function getCarId(uint256 _id) public view returns (uint256) {
        require(_id < cars.length, "Car does not exist");
        return cars[_id].id;
    }
}