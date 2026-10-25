package net.bigpoint.darkorbit.com.module.porting.events
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventLootShowCommand implements IModule
   {
      
      private static var _instance:EventLootShowCommand;
      
      public var lootAmount:int = 0;
      
      public var bg:String = "";
      
      public var lootId:String = "";
      
      public function EventLootShowCommand(param1:String = "", param2:int = 0, param3:String = "")
      {
         super();
         this.lootAmount = param2;
         this.bg = param3;
         this.lootId = param1;
      }
      
      public static function get instance() : EventLootShowCommand
      {
         return _instance || (_instance = new EventLootShowCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29419;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.lootAmount = param1.readInt();
         this.lootAmount = this.lootAmount << 13 % 32 | this.lootAmount >>> 32 - 13 % 32;
         this.bg = param1.readUTF();
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-29419);
         param1.writeInt(this.lootAmount >>> 13 % 32 | this.lootAmount << 32 - 13 % 32);
         param1.writeUTF(this.bg);
         param1.writeUTF(this.lootId);
      }
   }
}

