package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RemoveMineCommand implements IModule
   {
      
      private static var _instance:RemoveMineCommand;
      
      public var hash:String = "";
      
      public function RemoveMineCommand(param1:String = "")
      {
         super();
         this.hash = param1;
      }
      
      public static function get instance() : RemoveMineCommand
      {
         return _instance || (_instance = new RemoveMineCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19063;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.hash = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(19063);
         param1.writeUTF(this.hash);
      }
   }
}

