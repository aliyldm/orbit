package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SlotInfoCommand implements IModule
   {
      
      private static var _instance:SlotInfoCommand;
      
      public var menuItemId:String = "";
      
      public var slotId:int = 0;
      
      public function SlotInfoCommand(param1:int = 0, param2:String = "")
      {
         super();
         this.menuItemId = param2;
         this.slotId = param1;
      }
      
      public static function get instance() : SlotInfoCommand
      {
         return _instance || (_instance = new SlotInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -20408;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.menuItemId = param1.readUTF();
         this.slotId = param1.readInt();
         this.slotId = this.slotId << 4 % 32 | this.slotId >>> 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-20408);
         param1.writeUTF(this.menuItemId);
         param1.writeInt(this.slotId >>> 4 % 32 | this.slotId << 32 - 4 % 32);
      }
   }
}

