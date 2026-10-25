package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.messagestack.*;
   
   public class HangarShipRepairDroneCommand implements IModule
   {
      
      private static var _instance:HangarShipRepairDroneCommand;
      
      public var drones:Vector.<HangarShipDroneView>;
      
      public var errorMessage:BaseStackCommand;
      
      public var weaponEffect:Number = 0;
      
      public var resultId:int = 0;
      
      public var damage:Number = 0;
      
      public var droneId:Number = 0;
      
      public var shildEffect:Number = 0;
      
      public var level:int = 0;
      
      public function HangarShipRepairDroneCommand(param1:int = 0, param2:BaseStackCommand = null, param3:Number = 0, param4:int = 0, param5:Number = 0, param6:Number = 0, param7:Number = 0, param8:Vector.<HangarShipDroneView> = null)
      {
         super();
         if(param8 == null)
         {
            this.drones = new Vector.<HangarShipDroneView>();
         }
         else
         {
            this.drones = param8;
         }
         if(param2 == null)
         {
            this.errorMessage = new BaseStackCommand();
         }
         else
         {
            this.errorMessage = param2;
         }
         this.weaponEffect = param5;
         this.resultId = param1;
         this.damage = param7;
         this.droneId = param3;
         this.shildEffect = param6;
         this.level = param4;
      }
      
      public static function get instance() : HangarShipRepairDroneCommand
      {
         return _instance || (_instance = new HangarShipRepairDroneCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 28266;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 32;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:HangarShipDroneView = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.drones.length > 0)
         {
            this.drones.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = HangarShipDroneView(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.drones.push(_loc4_);
            _loc2_++;
         }
         this.errorMessage = BaseStackCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.errorMessage)
         {
            this.errorMessage.read(param1);
         }
         this.weaponEffect = param1.readFloat();
         this.resultId = param1.readInt();
         this.resultId = this.resultId >>> 4 % 32 | this.resultId << 32 - 4 % 32;
         this.damage = param1.readFloat();
         this.droneId = param1.readDouble();
         this.shildEffect = param1.readFloat();
         this.level = param1.readInt();
         this.level = this.level >>> 2 % 32 | this.level << 32 - 2 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:HangarShipDroneView = null;
         param1.writeShort(28266);
         param1.writeByte(this.drones.length);
         for each(_loc2_ in this.drones)
         {
            _loc2_.write(param1);
         }
         if(null != this.errorMessage)
         {
            this.errorMessage.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeFloat(this.weaponEffect);
         param1.writeInt(this.resultId << 4 % 32 | this.resultId >>> 32 - 4 % 32);
         param1.writeFloat(this.damage);
         param1.writeDouble(this.droneId);
         param1.writeFloat(this.shildEffect);
         param1.writeInt(this.level << 2 % 32 | this.level >>> 32 - 2 % 32);
      }
   }
}

