package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class BoosterUpdateModule implements IModule
   {
      
      private static var _instance:BoosterUpdateModule;
      
      public var attributeType:String = "";
      
      public var value:Number = 0;
      
      public function BoosterUpdateModule(param1:String = "", param2:Number = 0)
      {
         super();
         this.attributeType = param1;
         this.value = param2;
      }
      
      public static function get instance() : BoosterUpdateModule
      {
         return _instance || (_instance = new BoosterUpdateModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 100;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 6;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.attributeType = param1.readUTF();
         this.value = param1.readFloat();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(100);
         param1.writeUTF(this.attributeType);
         param1.writeFloat(this.value);
      }
   }
}

