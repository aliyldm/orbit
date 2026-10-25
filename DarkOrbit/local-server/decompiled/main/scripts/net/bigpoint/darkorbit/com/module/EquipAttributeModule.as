package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EquipAttributeModule implements IModule
   {
      
      private static var _instance:EquipAttributeModule;
      
      public var AttributeValue:int = 0;
      
      public var maxAttributeValue:int = 0;
      
      public var upMin:int = 0;
      
      public var upMax:int = 0;
      
      public var AttributeID:String = "";
      
      public function EquipAttributeModule(param1:String = "", param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0)
      {
         super();
         this.AttributeValue = param2;
         this.maxAttributeValue = param3;
         this.upMin = param4;
         this.upMax = param5;
         this.AttributeID = param1;
      }
      
      public static function get instance() : EquipAttributeModule
      {
         return _instance || (_instance = new EquipAttributeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22566;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 18;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.AttributeValue = param1.readInt();
         this.AttributeValue = this.AttributeValue << 14 % 32 | this.AttributeValue >>> 32 - 14 % 32;
         this.maxAttributeValue = param1.readInt();
         this.maxAttributeValue = this.maxAttributeValue >>> 8 % 32 | this.maxAttributeValue << 32 - 8 % 32;
         this.upMin = param1.readInt();
         this.upMin = this.upMin << 2 % 32 | this.upMin >>> 32 - 2 % 32;
         this.upMax = param1.readInt();
         this.upMax = this.upMax << 11 % 32 | this.upMax >>> 32 - 11 % 32;
         this.AttributeID = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-22566);
         param1.writeInt(this.AttributeValue >>> 14 % 32 | this.AttributeValue << 32 - 14 % 32);
         param1.writeInt(this.maxAttributeValue << 8 % 32 | this.maxAttributeValue >>> 32 - 8 % 32);
         param1.writeInt(this.upMin >>> 2 % 32 | this.upMin << 32 - 2 % 32);
         param1.writeInt(this.upMax >>> 11 % 32 | this.upMax << 32 - 11 % 32);
         param1.writeUTF(this.AttributeID);
      }
   }
}

