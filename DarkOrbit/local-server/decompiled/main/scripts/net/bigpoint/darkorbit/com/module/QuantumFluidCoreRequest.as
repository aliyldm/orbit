package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuantumFluidCoreRequest implements IModule
   {
      
      private static var _instance:QuantumFluidCoreRequest;
      
      public static const REQTYPE_none:int = 0;
      
      public static const REQTYPE_forge:int = 1;
      
      public static const REQTYPE_recycle:int = 2;
      
      public static const REQTYPE__MAX:int = 3;
      
      public var ItemId:Number = 0;
      
      public var type:int = 0;
      
      public function QuantumFluidCoreRequest(param1:Number = 0, param2:int = 0)
      {
         super();
         this.ItemId = param1;
         this.type = param2;
      }
      
      public static function get instance() : QuantumFluidCoreRequest
      {
         return _instance || (_instance = new QuantumFluidCoreRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29807;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.ItemId = param1.readDouble();
         this.type = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-29807);
         param1.writeDouble(this.ItemId);
         param1.writeShort(this.type);
      }
   }
}

