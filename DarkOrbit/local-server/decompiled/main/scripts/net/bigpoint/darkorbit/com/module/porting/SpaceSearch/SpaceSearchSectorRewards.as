package net.bigpoint.darkorbit.com.module.porting.SpaceSearch
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SpaceSearchSectorRewards implements IModule
   {
      
      private static var _instance:SpaceSearchSectorRewards;
      
      public var unlock:Boolean = false;
      
      public var count:int = 0;
      
      public var range:int = 0;
      
      public var received:Boolean = false;
      
      public function SpaceSearchSectorRewards(param1:int = 0, param2:int = 0, param3:Boolean = false, param4:Boolean = false)
      {
         super();
         this.unlock = param3;
         this.count = param2;
         this.range = param1;
         this.received = param4;
      }
      
      public static function get instance() : SpaceSearchSectorRewards
      {
         return _instance || (_instance = new SpaceSearchSectorRewards());
      }
      
      public function getLibcomModuleId() : int
      {
         return 7011;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.unlock = param1.readBoolean();
         this.count = param1.readInt();
         this.count = this.count << 13 % 32 | this.count >>> 32 - 13 % 32;
         this.range = param1.readInt();
         this.range = this.range >>> 10 % 32 | this.range << 32 - 10 % 32;
         this.received = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7011);
         param1.writeBoolean(this.unlock);
         param1.writeInt(this.count >>> 13 % 32 | this.count << 32 - 13 % 32);
         param1.writeInt(this.range << 10 % 32 | this.range >>> 32 - 10 % 32);
         param1.writeBoolean(this.received);
      }
   }
}

