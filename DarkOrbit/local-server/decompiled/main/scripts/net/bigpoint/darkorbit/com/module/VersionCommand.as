package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VersionCommand implements IModule
   {
      
      private static var _instance:VersionCommand;
      
      public var version:String = "";
      
      public var equal:Boolean = false;
      
      public function VersionCommand(param1:String = "", param2:Boolean = false)
      {
         super();
         this.version = param1;
         this.equal = param2;
      }
      
      public static function get instance() : VersionCommand
      {
         return _instance || (_instance = new VersionCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 667;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 3;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.version = param1.readUTF();
         this.equal = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(667);
         param1.writeUTF(this.version);
         param1.writeBoolean(this.equal);
      }
   }
}

