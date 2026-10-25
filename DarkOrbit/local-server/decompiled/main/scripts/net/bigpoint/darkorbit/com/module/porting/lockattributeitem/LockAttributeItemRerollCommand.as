package net.bigpoint.darkorbit.com.module.porting.lockattributeitem
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LockAttributeItemRerollCommand implements IModule
   {
      
      private static var _instance:LockAttributeItemRerollCommand;
      
      public var result:Boolean = false;
      
      public function LockAttributeItemRerollCommand(param1:Boolean = false)
      {
         super();
         this.result = param1;
      }
      
      public static function get instance() : LockAttributeItemRerollCommand
      {
         return _instance || (_instance = new LockAttributeItemRerollCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17217;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.result = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(17217);
         param1.writeBoolean(this.result);
      }
   }
}

