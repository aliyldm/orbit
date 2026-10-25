package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class HangarShipEquipmentCommand implements IModule
   {
      
      private static var _instance:HangarShipEquipmentCommand;
      
      public var hangarId:Number = 0;
      
      public var droneConfigs:Vector.<HangarDroneEquipmentMsg>;
      
      public var petConfigs:Vector.<HangarPetEquipmentMsg>;
      
      public var extrasSlotsSize2:int = 0;
      
      public var lootId:String = "";
      
      public var shipId:Number = 0;
      
      public var extrasSlotsSize1:int = 0;
      
      public var currentConfigId:int = 0;
      
      public var shipConfigs:Vector.<HangarShipEquipmentMsg>;
      
      public function HangarShipEquipmentCommand(param1:Number = 0, param2:Number = 0, param3:String = "", param4:int = 0, param5:int = 0, param6:int = 0, param7:Vector.<HangarShipEquipmentMsg> = null, param8:Vector.<HangarDroneEquipmentMsg> = null, param9:Vector.<HangarPetEquipmentMsg> = null)
      {
         super();
         this.hangarId = param1;
         if(param8 == null)
         {
            this.droneConfigs = new Vector.<HangarDroneEquipmentMsg>();
         }
         else
         {
            this.droneConfigs = param8;
         }
         if(param9 == null)
         {
            this.petConfigs = new Vector.<HangarPetEquipmentMsg>();
         }
         else
         {
            this.petConfigs = param9;
         }
         this.extrasSlotsSize2 = param5;
         this.lootId = param3;
         this.shipId = param2;
         this.extrasSlotsSize1 = param4;
         this.currentConfigId = param6;
         if(param7 == null)
         {
            this.shipConfigs = new Vector.<HangarShipEquipmentMsg>();
         }
         else
         {
            this.shipConfigs = param7;
         }
      }
      
      public static function get instance() : HangarShipEquipmentCommand
      {
         return _instance || (_instance = new HangarShipEquipmentCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22505;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 42;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:HangarDroneEquipmentMsg = null;
         var _loc5_:HangarPetEquipmentMsg = null;
         var _loc6_:HangarShipEquipmentMsg = null;
         this.hangarId = param1.readDouble();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.droneConfigs.length > 0)
         {
            this.droneConfigs.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = HangarDroneEquipmentMsg(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.droneConfigs.push(_loc4_);
            _loc2_++;
         }
         while(this.petConfigs.length > 0)
         {
            this.petConfigs.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = HangarPetEquipmentMsg(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.petConfigs.push(_loc5_);
            _loc2_++;
         }
         this.extrasSlotsSize2 = param1.readInt();
         this.extrasSlotsSize2 = this.extrasSlotsSize2 << 14 % 32 | this.extrasSlotsSize2 >>> 32 - 14 % 32;
         this.lootId = param1.readUTF();
         this.shipId = param1.readDouble();
         this.extrasSlotsSize1 = param1.readInt();
         this.extrasSlotsSize1 = this.extrasSlotsSize1 >>> 2 % 32 | this.extrasSlotsSize1 << 32 - 2 % 32;
         this.currentConfigId = param1.readInt();
         this.currentConfigId = this.currentConfigId << 6 % 32 | this.currentConfigId >>> 32 - 6 % 32;
         while(this.shipConfigs.length > 0)
         {
            this.shipConfigs.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = HangarShipEquipmentMsg(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.shipConfigs.push(_loc6_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:HangarDroneEquipmentMsg = null;
         var _loc3_:HangarPetEquipmentMsg = null;
         var _loc4_:HangarShipEquipmentMsg = null;
         param1.writeShort(-22505);
         param1.writeDouble(this.hangarId);
         param1.writeByte(this.droneConfigs.length);
         for each(_loc2_ in this.droneConfigs)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.petConfigs.length);
         for each(_loc3_ in this.petConfigs)
         {
            _loc3_.write(param1);
         }
         param1.writeInt(this.extrasSlotsSize2 >>> 14 % 32 | this.extrasSlotsSize2 << 32 - 14 % 32);
         param1.writeUTF(this.lootId);
         param1.writeDouble(this.shipId);
         param1.writeInt(this.extrasSlotsSize1 << 2 % 32 | this.extrasSlotsSize1 >>> 32 - 2 % 32);
         param1.writeInt(this.currentConfigId >>> 6 % 32 | this.currentConfigId << 32 - 6 % 32);
         param1.writeByte(this.shipConfigs.length);
         for each(_loc4_ in this.shipConfigs)
         {
            _loc4_.write(param1);
         }
      }
   }
}

