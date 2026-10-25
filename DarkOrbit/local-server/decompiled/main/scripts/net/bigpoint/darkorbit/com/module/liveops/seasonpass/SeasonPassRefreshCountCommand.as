package net.bigpoint.darkorbit.com.module.liveops.seasonpass
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SeasonPassRefreshCountCommand implements IModule
   {
      
      private static var _instance:SeasonPassRefreshCountCommand;
      
      public var weekCurrent:int = 0;
      
      public var isGold:Boolean = false;
      
      public var dayCurrent:int = 0;
      
      public var weekMax:int = 0;
      
      public var dayMax:int = 0;
      
      public function SeasonPassRefreshCountCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:Boolean = false)
      {
         super();
         this.weekCurrent = param3;
         this.isGold = param5;
         this.dayCurrent = param1;
         this.weekMax = param4;
         this.dayMax = param2;
      }
      
      public static function get instance() : SeasonPassRefreshCountCommand
      {
         return _instance || (_instance = new SeasonPassRefreshCountCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 16049;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 17;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.weekCurrent = param1.readInt();
         this.weekCurrent = this.weekCurrent << 13 % 32 | this.weekCurrent >>> 32 - 13 % 32;
         this.isGold = param1.readBoolean();
         this.dayCurrent = param1.readInt();
         this.dayCurrent = this.dayCurrent >>> 2 % 32 | this.dayCurrent << 32 - 2 % 32;
         this.weekMax = param1.readInt();
         this.weekMax = this.weekMax >>> 16 % 32 | this.weekMax << 32 - 16 % 32;
         this.dayMax = param1.readInt();
         this.dayMax = this.dayMax << 8 % 32 | this.dayMax >>> 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(16049);
         param1.writeInt(this.weekCurrent >>> 13 % 32 | this.weekCurrent << 32 - 13 % 32);
         param1.writeBoolean(this.isGold);
         param1.writeInt(this.dayCurrent << 2 % 32 | this.dayCurrent >>> 32 - 2 % 32);
         param1.writeInt(this.weekMax << 16 % 32 | this.weekMax >>> 32 - 16 % 32);
         param1.writeInt(this.dayMax >>> 8 % 32 | this.dayMax << 32 - 8 % 32);
      }
   }
}

