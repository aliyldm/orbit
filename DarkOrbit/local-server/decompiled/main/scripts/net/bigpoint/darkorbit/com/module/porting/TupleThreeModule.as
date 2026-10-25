package net.bigpoint.darkorbit.com.module.porting
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TupleThreeModule implements IModule
   {
      
      private static var _instance:TupleThreeModule;
      
      public var param1:String = "";
      
      public var param2:String = "";
      
      public var param0:String = "";
      
      public function TupleThreeModule(param1:String = "", param2:String = "", param3:String = "")
      {
         super();
         this.param1 = param2;
         this.param2 = param3;
         this.param0 = param1;
      }
      
      public static function get instance() : TupleThreeModule
      {
         return _instance || (_instance = new TupleThreeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 21778;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.param1 = param1.readUTF();
         this.param2 = param1.readUTF();
         this.param0 = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(21778);
         param1.writeUTF(this.param1);
         param1.writeUTF(this.param2);
         param1.writeUTF(this.param0);
      }
   }
}

