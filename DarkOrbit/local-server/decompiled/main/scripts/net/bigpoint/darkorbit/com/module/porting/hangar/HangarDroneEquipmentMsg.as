package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class HangarDroneEquipmentMsg implements IModule
   {
      
      private static var _instance:HangarDroneEquipmentMsg;
      
      public var setId:int = 0;
      
      public var active:Boolean = false;
      
      public var position:int = 0;
      
      public var setDroneEquipment:Vector.<SingleDroneEquipmentMsg>;
      
      public function HangarDroneEquipmentMsg(param1:int = 0, param2:Boolean = false, param3:int = 0, param4:Vector.<SingleDroneEquipmentMsg> = null)
      {
         super();
         this.setId = param1;
         this.active = param2;
         this.position = param3;
         if(param4 == null)
         {
            this.setDroneEquipment = new Vector.<SingleDroneEquipmentMsg>();
         }
         else
         {
            this.setDroneEquipment = param4;
         }
      }
      
      public static function get instance() : HangarDroneEquipmentMsg
      {
         return _instance || (_instance = new HangarDroneEquipmentMsg());
      }
      
      public function getLibcomModuleId() : int
      {
         return -27341;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 13;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SingleDroneEquipmentMsg = null;
         this.setId = param1.readInt();
         this.setId = this.setId >>> 8 % 32 | this.setId << 32 - 8 % 32;
         this.active = param1.readBoolean();
         this.position = param1.readInt();
         this.position = this.position << 6 % 32 | this.position >>> 32 - 6 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.setDroneEquipment.length > 0)
         {
            this.setDroneEquipment.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SingleDroneEquipmentMsg(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.setDroneEquipment.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SingleDroneEquipmentMsg = null;
         param1.writeShort(-27341);
         param1.writeInt(this.setId << 8 % 32 | this.setId >>> 32 - 8 % 32);
         param1.writeBoolean(this.active);
         param1.writeInt(this.position >>> 6 % 32 | this.position << 32 - 6 % 32);
         param1.writeByte(this.setDroneEquipment.length);
         for each(_loc2_ in this.setDroneEquipment)
         {
            _loc2_.write(param1);
         }
      }
   }
}

