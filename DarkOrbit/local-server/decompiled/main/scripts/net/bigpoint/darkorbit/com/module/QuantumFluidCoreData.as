package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class QuantumFluidCoreData implements IModule
   {
      
      private static var _instance:QuantumFluidCoreData;
      
      public var equipAttributes:Vector.<EquipAttributeModule>;
      
      public var quality:int = 0;
      
      public var sellPrice:int = 0;
      
      public var itemId:Number = 0;
      
      public var useLootId:String = "";
      
      public var shipIds:Vector.<String>;
      
      public var unlock:int = 0;
      
      public var lv:int = 0;
      
      public var spendPrice:int = 0;
      
      public var maxLv:int = 0;
      
      public var lootId:String = "";
      
      public function QuantumFluidCoreData(param1:String = "", param2:Number = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:Vector.<String> = null, param7:Vector.<EquipAttributeModule> = null, param8:String = "", param9:int = 0, param10:int = 0, param11:int = 0)
      {
         super();
         if(param7 == null)
         {
            this.equipAttributes = new Vector.<EquipAttributeModule>();
         }
         else
         {
            this.equipAttributes = param7;
         }
         this.quality = param5;
         this.sellPrice = param9;
         this.itemId = param2;
         this.useLootId = param8;
         if(param6 == null)
         {
            this.shipIds = new Vector.<String>();
         }
         else
         {
            this.shipIds = param6;
         }
         this.unlock = param11;
         this.lv = param3;
         this.spendPrice = param10;
         this.maxLv = param4;
         this.lootId = param1;
      }
      
      public static function get instance() : QuantumFluidCoreData
      {
         return _instance || (_instance = new QuantumFluidCoreData());
      }
      
      public function getLibcomModuleId() : int
      {
         return -6217;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 44;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EquipAttributeModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.equipAttributes.length > 0)
         {
            this.equipAttributes.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = EquipAttributeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.equipAttributes.push(_loc4_);
            _loc2_++;
         }
         this.quality = param1.readInt();
         this.quality = this.quality << 10 % 32 | this.quality >>> 32 - 10 % 32;
         this.sellPrice = param1.readInt();
         this.sellPrice = this.sellPrice >>> 13 % 32 | this.sellPrice << 32 - 13 % 32;
         this.itemId = param1.readDouble();
         this.useLootId = param1.readUTF();
         while(this.shipIds.length > 0)
         {
            this.shipIds.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            this.shipIds.push(param1.readUTF());
            _loc2_++;
         }
         this.unlock = param1.readInt();
         this.unlock = this.unlock >>> 14 % 32 | this.unlock << 32 - 14 % 32;
         this.lv = param1.readInt();
         this.lv = this.lv >>> 6 % 32 | this.lv << 32 - 6 % 32;
         this.spendPrice = param1.readInt();
         this.spendPrice = this.spendPrice << 10 % 32 | this.spendPrice >>> 32 - 10 % 32;
         this.maxLv = param1.readInt();
         this.maxLv = this.maxLv << 9 % 32 | this.maxLv >>> 32 - 9 % 32;
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EquipAttributeModule = null;
         var _loc3_:String = null;
         param1.writeShort(-6217);
         param1.writeByte(this.equipAttributes.length);
         for each(_loc2_ in this.equipAttributes)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.quality >>> 10 % 32 | this.quality << 32 - 10 % 32);
         param1.writeInt(this.sellPrice << 13 % 32 | this.sellPrice >>> 32 - 13 % 32);
         param1.writeDouble(this.itemId);
         param1.writeUTF(this.useLootId);
         param1.writeByte(this.shipIds.length);
         for each(_loc3_ in this.shipIds)
         {
            param1.writeUTF(_loc3_);
         }
         param1.writeInt(this.unlock << 14 % 32 | this.unlock >>> 32 - 14 % 32);
         param1.writeInt(this.lv << 6 % 32 | this.lv >>> 32 - 6 % 32);
         param1.writeInt(this.spendPrice >>> 10 % 32 | this.spendPrice << 32 - 10 % 32);
         param1.writeInt(this.maxLv >>> 9 % 32 | this.maxLv << 32 - 9 % 32);
         param1.writeUTF(this.lootId);
      }
   }
}

