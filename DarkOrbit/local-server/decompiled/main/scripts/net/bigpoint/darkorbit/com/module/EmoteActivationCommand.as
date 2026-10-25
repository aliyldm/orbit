package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EmoteActivationCommand implements IModule
   {
      
      private static var _instance:EmoteActivationCommand;
      
      public var userId:int = 0;
      
      public var lootId:String = "";
      
      public function EmoteActivationCommand(param1:String = "", param2:int = 0)
      {
         super();
         this.userId = param2;
         this.lootId = param1;
      }
      
      public static function get instance() : EmoteActivationCommand
      {
         return _instance || (_instance = new EmoteActivationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 4739;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.userId = param1.readInt();
         this.userId = this.userId << 5 % 32 | this.userId >>> 32 - 5 % 32;
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(4739);
         param1.writeInt(this.userId >>> 5 % 32 | this.userId << 32 - 5 % 32);
         param1.writeUTF(this.lootId);
      }
   }
}

