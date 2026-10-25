package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RemoveCollectableCommand implements IModule
   {
      
      private static var _instance:RemoveCollectableCommand;
      
      public var collected:Boolean = false;
      
      public var hash:String = "";
      
      public function RemoveCollectableCommand(param1:String = "", param2:Boolean = false)
      {
         super();
         this.collected = param2;
         this.hash = param1;
      }
      
      public static function get instance() : RemoveCollectableCommand
      {
         return _instance || (_instance = new RemoveCollectableCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -6137;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 3;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.collected = param1.readBoolean();
         this.hash = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-6137);
         param1.writeBoolean(this.collected);
         param1.writeUTF(this.hash);
      }
   }
}

