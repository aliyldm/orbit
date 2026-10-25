package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ContactUiUnblockCommand implements IModule
   {
      
      private static var _instance:ContactUiUnblockCommand;
      
      public function ContactUiUnblockCommand()
      {
         super();
      }
      
      public static function get instance() : ContactUiUnblockCommand
      {
         return _instance || (_instance = new ContactUiUnblockCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 14139;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(14139);
      }
   }
}

