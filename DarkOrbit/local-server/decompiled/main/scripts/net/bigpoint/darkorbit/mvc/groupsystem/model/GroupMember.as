package net.bigpoint.darkorbit.mvc.groupsystem.model
{
   public class GroupMember
   {
      
      public var id:int;
      
      public var nickName:String;
      
      public var factionID:int;
      
      public var gameLevel:int;
      
      public var clanTag:String;
      
      public var online:Boolean = true;
      
      public var alive:Boolean = true;
      
      public var mapID:int;
      
      public var posX:int;
      
      public var posY:int;
      
      public var memberObject:StubShip = new StubShip();
      
      public var targetObject:StubShip = new StubShip();
      
      public var activity:Boolean;
      
      public var fightState:Boolean;
      
      public var isCloaked:Boolean;
      
      public var orderID:int;
      
      public var isLead:Boolean;
      
      public var isOffline:Boolean;
      
      public var raidGateStatus:int;
      
      public var isInRaidGate:Boolean;
      
      public var isSelected:Boolean;
      
      public function GroupMember()
      {
         super();
         this.nickName = "";
      }
      
      public function init(param1:int = 0, param2:String = "", param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:int = 0, param12:int = 0, param13:Boolean = false, param14:Boolean = false, param15:Boolean = false, param16:int = 0, param17:int = 0, param18:String = "", param19:int = 0, param20:Boolean = false, param21:int = 0) : void
      {
         this.id = param1;
         this.nickName = param2;
         this.memberObject.hitPointsCurrent = param3;
         this.memberObject.hitPointsMax = param4;
         this.memberObject.nanohullCurrent = param5;
         this.memberObject.nanohullMax = param6;
         this.memberObject.shieldCurrent = param7;
         this.memberObject.shieldMax = param8;
         this.mapID = param9;
         this.posX = param10;
         this.posY = param11;
         this.gameLevel = param12;
         this.activity = param13;
         this.isCloaked = param14;
         this.fightState = param15;
         this.factionID = param16;
         this.memberObject.shipType = param17;
         this.clanTag = param18;
         this.targetObject.shipType = param19;
         this.isOffline = param20;
         this.raidGateStatus = param21;
      }
   }
}

