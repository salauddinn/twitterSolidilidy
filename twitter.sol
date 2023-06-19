// SPDX-License-Identifier: MIT

pragma solidity >=0.5.0 <0.9.0;



contract TweetContract {

struct Tweet{

    uint id;
    address author;
    string content;
    uint createdAt;
}
struct Message{
    uint id;
    string content;
    address from;
    address to;
    uint createdAt;
}
mapping(uint =>Tweet) public tweets;
mapping (address=> uint[]) public  tweetsOf;
mapping(address=>Message[]) conversations;
mapping(address=>mapping(address=>bool)) public  operators;
mapping (address=>address[]) public  following;

uint nextId;
uint nextMessageId;

function _tweet(address _from,string memory content) internal
{

    require(_from == msg.sender || operators[_from][msg.sender],"YOu don't have acess");

    tweets[nextId]=Tweet(nextId,_from,content,block.timestamp);
    tweetsOf[_from].push(nextId);
    nextId=nextId+1;
}

function _sendMessage(address _from,address _to,string memory _content) internal {
    require(_from == msg.sender|| operators[_from][msg.sender],"You don't have acess");
    conversations[_from].push(Message(nextMessageId,_content,_from,_to,block.timestamp));
    nextMessageId=nextMessageId+1;
}

function tweet(string memory _content) public {
    _tweet(msg.sender, _content);
}
function tweet(address _from, string memory _content) public {
    _tweet(_from, _content);
}

function sendMessage(address _to,string memory _content) public {
    _sendMessage(msg.sender, _to, _content);
}

function sendMessage(address _from,address _to,string memory _content) public {
    _sendMessage(_from, _to, _content);
}
function follow(address followed) public {
 following[msg.sender].push(followed);
}
function allow(address operator) public {
    operators[msg.sender][operator]=true;
}
function disallow(address operator) public  {
operators[msg.sender][operator]=false;
}
function getLatestTweets(uint count) public view returns(Tweet[] memory)  {

    require(count>0 && count<=nextId,"Count is not proper");
    Tweet[] memory _tweets=new Tweet[](count);
    uint j;
    for(uint i=nextId-count;i<nextId;i++){
        Tweet storage _structure= tweets[i];
        _tweets[j]=Tweet(_structure.id,
        _structure.author,
        _structure.content,
        _structure.createdAt
        );
        j=j+1;
    }
    return _tweets;

}

function getLatestTwetOfUser(address user,uint count) public view returns(Tweet[] memory)  {
    Tweet[] memory _tweets=new Tweet[](count);
    
    uint[] memory ids=tweetsOf[user];
    require(count>0 && count<=ids.length,"Count is not proper");
    uint j;
    for(uint i=ids.length-count;i<ids.length;i++){
        Tweet storage _structure= tweets[ids[i]];
        _tweets[j]=Tweet(_structure.id,
        _structure.author,
        _structure.content,
        _structure.createdAt
        );
        j=j+1;
    }
    return _tweets;

}

} 
