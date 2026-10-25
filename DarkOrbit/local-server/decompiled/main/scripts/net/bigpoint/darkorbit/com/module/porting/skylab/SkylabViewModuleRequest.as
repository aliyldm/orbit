package net.bigpoint.darkorbit.com.module.porting.skylab
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SkylabViewModuleRequest implements IModule
   {
      
      private static var _instance:SkylabViewModuleRequest;
      
      public var moduleName:String = "";
      
      public function SkylabViewModuleRequest(param1:String = "")
      {
         super();
         this.moduleName = param1;
      }
      
      public static function get instance() : SkylabViewModuleRequest
      {
         return _instance || (_instance = new SkylabViewModuleRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -15147;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.moduleName = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-15147);
         param1.writeUTF(this.moduleName);
      }
   }
}

