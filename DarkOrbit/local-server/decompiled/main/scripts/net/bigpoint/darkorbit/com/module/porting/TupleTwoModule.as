package net.bigpoint.darkorbit.com.module.porting
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TupleTwoModule implements IModule
   {
      
      private static var _instance:TupleTwoModule;
      
      public var param0:String = "";
      
      public var param1:String = "";
      
      public function TupleTwoModule(param1:String = "", param2:String = "")
      {
         super();
         this.param0 = param1;
         this.param1 = param2;
      }
      
      public static function get instance() : TupleTwoModule
      {
         return _instance || (_instance = new TupleTwoModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 741;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.param0 = param1.readUTF();
         this.param1 = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(741);
         param1.writeUTF(this.param0);
         param1.writeUTF(this.param1);
      }
   }
}

