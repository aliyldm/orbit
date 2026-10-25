package net.bigpoint.darkorbit.com.module.porting.SpaceSearch
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SpaceSearchRequest implements IModule
   {
      
      private static var _instance:SpaceSearchRequest;
      
      public static const ACTION_ssAtlas:int = 0;
      
      public static const ACTION_ssSearch:int = 1;
      
      public static const ACTION_ssSectorRewardsList:int = 2;
      
      public static const ACTION_ssSectorRewardsGet:int = 3;
      
      public static const ACTION_ssMissionList:int = 4;
      
      public static const ACTION__MAX:int = 5;
      
      public var id:int = 0;
      
      public var action:int = 0;
      
      public var count:int = 0;
      
      public function SpaceSearchRequest(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.id = param2;
         this.action = param1;
         this.count = param3;
      }
      
      public static function get instance() : SpaceSearchRequest
      {
         return _instance || (_instance = new SpaceSearchRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1558;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.id = param1.readInt();
         this.id = this.id >>> 11 % 32 | this.id << 32 - 11 % 32;
         this.action = param1.readShort();
         this.count = param1.readInt();
         this.count = this.count << 9 % 32 | this.count >>> 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1558);
         param1.writeInt(this.id << 11 % 32 | this.id >>> 32 - 11 % 32);
         param1.writeShort(this.action);
         param1.writeInt(this.count >>> 9 % 32 | this.count << 32 - 9 % 32);
      }
   }
}

