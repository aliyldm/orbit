package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CCValueModule implements IModule
   {
      
      private static var _instance:CCValueModule;
      
      public var name:String = "";
      
      public function CCValueModule(param1:String = "")
      {
         super();
         this.name = param1;
      }
      
      public static function get instance() : CCValueModule
      {
         return _instance || (_instance = new CCValueModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -11273;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.name = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-11273);
         param1.writeUTF(this.name);
      }
   }
}

