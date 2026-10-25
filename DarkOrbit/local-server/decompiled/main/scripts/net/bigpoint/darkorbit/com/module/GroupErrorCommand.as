package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GroupErrorCommand implements IModule
   {
      
      private static var _instance:GroupErrorCommand;
      
      public static const ERRORTYPE_PING_FAILED:int = 0;
      
      public static const ERRORTYPE_NO_GROUP:int = 1;
      
      public static const ERRORTYPE_FOLLOW_FAILED:int = 2;
      
      public static const ERRORTYPE_NO_INVITATION:int = 3;
      
      public static const ERRORTYPE__MAX:int = 4;
      
      public var type:int = 0;
      
      public function GroupErrorCommand(param1:int = 0)
      {
         super();
         this.type = param1;
      }
      
      public static function get instance() : GroupErrorCommand
      {
         return _instance || (_instance = new GroupErrorCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3575;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.type = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3575);
         param1.writeShort(this.type);
      }
   }
}

