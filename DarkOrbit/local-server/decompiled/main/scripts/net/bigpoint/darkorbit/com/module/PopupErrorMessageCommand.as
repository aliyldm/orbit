package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PopupErrorMessageCommand implements IModule
   {
      
      private static var _instance:PopupErrorMessageCommand;
      
      public static const ERROR_CODE_ASSEMBLY_GENERAL_ERROR:int = 0;
      
      public static const ERROR_CODE__MAX:int = 1;
      
      public var errorCode:int = 0;
      
      public function PopupErrorMessageCommand(param1:int = 0)
      {
         super();
         this.errorCode = param1;
      }
      
      public static function get instance() : PopupErrorMessageCommand
      {
         return _instance || (_instance = new PopupErrorMessageCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 9421;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.errorCode = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(9421);
         param1.writeShort(this.errorCode);
      }
   }
}

