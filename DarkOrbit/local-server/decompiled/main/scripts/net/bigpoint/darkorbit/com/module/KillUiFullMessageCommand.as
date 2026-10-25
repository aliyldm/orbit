package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class KillUiFullMessageCommand implements IModule
   {
      
      private static var _instance:KillUiFullMessageCommand;
      
      public var totalAmountOfNpcOnMap:int = 0;
      
      public var mapId:int = 0;
      
      public var npcId:int = 0;
      
      public function KillUiFullMessageCommand(param1:int = 0, param2:int = 0, param3:int = 0)
      {
         super();
         this.totalAmountOfNpcOnMap = param3;
         this.mapId = param1;
         this.npcId = param2;
      }
      
      public static function get instance() : KillUiFullMessageCommand
      {
         return _instance || (_instance = new KillUiFullMessageCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 672;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.totalAmountOfNpcOnMap = param1.readInt();
         this.totalAmountOfNpcOnMap = this.totalAmountOfNpcOnMap << 10 % 32 | this.totalAmountOfNpcOnMap >>> 32 - 10 % 32;
         this.mapId = param1.readInt();
         this.mapId = this.mapId >>> 9 % 32 | this.mapId << 32 - 9 % 32;
         this.npcId = param1.readInt();
         this.npcId = this.npcId >>> 6 % 32 | this.npcId << 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(672);
         param1.writeInt(this.totalAmountOfNpcOnMap >>> 10 % 32 | this.totalAmountOfNpcOnMap << 32 - 10 % 32);
         param1.writeInt(this.mapId << 9 % 32 | this.mapId >>> 32 - 9 % 32);
         param1.writeInt(this.npcId << 6 % 32 | this.npcId >>> 32 - 6 % 32);
      }
   }
}

