package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class NameChangeCommand implements IModule
   {
      
      private static var _instance:NameChangeCommand;
      
      public var userId:int = 0;
      
      public var newName:String = "";
      
      public function NameChangeCommand(param1:int = 0, param2:String = "")
      {
         super();
         this.userId = param1;
         this.newName = param2;
      }
      
      public static function get instance() : NameChangeCommand
      {
         return _instance || (_instance = new NameChangeCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -1585;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userId = param1.readInt();
         this.userId = this.userId >>> 2 % 32 | this.userId << 32 - 2 % 32;
         this.newName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-1585);
         param1.writeInt(this.userId << 2 % 32 | this.userId >>> 32 - 2 % 32);
         param1.writeUTF(this.newName);
      }
   }
}

