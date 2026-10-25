package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderInfoCommand implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderInfoCommand;
      
      public var bonusRewardsDay:Boolean = false;
      
      public var spinamount_selected:int = 0;
      
      public var spinAmounts:Vector.<int>;
      
      public var samples:Number = 0;
      
      public var energy_cost:int = 0;
      
      public var spinOnSale:Boolean = false;
      
      public var money:Number = 0;
      
      public var gates:Vector.<GalaxyGateBuilderGateModule>;
      
      public var galaxyGateDay:Boolean = false;
      
      public function GalaxyGateBuilderInfoCommand(param1:Number = 0, param2:Number = 0, param3:int = 0, param4:int = 0, param5:Boolean = false, param6:Boolean = false, param7:Boolean = false, param8:Vector.<int> = null, param9:Vector.<GalaxyGateBuilderGateModule> = null)
      {
         super();
         this.bonusRewardsDay = param7;
         this.spinamount_selected = param4;
         if(param8 == null)
         {
            this.spinAmounts = new Vector.<int>();
         }
         else
         {
            this.spinAmounts = param8;
         }
         this.samples = param2;
         this.energy_cost = param3;
         this.spinOnSale = param5;
         this.money = param1;
         if(param9 == null)
         {
            this.gates = new Vector.<GalaxyGateBuilderGateModule>();
         }
         else
         {
            this.gates = param9;
         }
         this.galaxyGateDay = param6;
      }
      
      public static function get instance() : GalaxyGateBuilderInfoCommand
      {
         return _instance || (_instance = new GalaxyGateBuilderInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -20312;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 30;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         var _loc5_:GalaxyGateBuilderGateModule = null;
         this.bonusRewardsDay = param1.readBoolean();
         this.spinamount_selected = param1.readByte();
         this.spinamount_selected = 0xFF & ((0xFF & this.spinamount_selected) << 7 % 8 | (0xFF & this.spinamount_selected) >>> 8 - 7 % 8);
         this.spinamount_selected = this.spinamount_selected > 127 ? int(this.spinamount_selected - 256) : this.spinamount_selected;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.spinAmounts.length > 0)
         {
            this.spinAmounts.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readByte();
            _loc4_ = 0xFF & ((0xFF & _loc4_) >>> 5 % 8 | (0xFF & _loc4_) << 8 - 5 % 8);
            _loc4_ = _loc4_ > 127 ? int(_loc4_ - 256) : _loc4_;
            this.spinAmounts.push(_loc4_);
            _loc2_++;
         }
         this.samples = param1.readDouble();
         this.energy_cost = param1.readShort();
         this.energy_cost = 0xFFFF & ((0xFFFF & this.energy_cost) << 13 % 16 | (0xFFFF & this.energy_cost) >>> 16 - 13 % 16);
         this.energy_cost = this.energy_cost > 32767 ? int(this.energy_cost - 65536) : this.energy_cost;
         this.spinOnSale = param1.readBoolean();
         this.money = param1.readDouble();
         while(this.gates.length > 0)
         {
            this.gates.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = GalaxyGateBuilderGateModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.gates.push(_loc5_);
            _loc2_++;
         }
         this.galaxyGateDay = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:GalaxyGateBuilderGateModule = null;
         param1.writeShort(-20312);
         param1.writeBoolean(this.bonusRewardsDay);
         param1.writeByte(0xFF & ((0xFF & this.spinamount_selected) >>> 7 % 8 | (0xFF & this.spinamount_selected) << 8 - 7 % 8));
         param1.writeByte(this.spinAmounts.length);
         for each(_loc2_ in this.spinAmounts)
         {
            param1.writeByte(0xFF & ((0xFF & _loc2_) << 5 % 8 | (0xFF & _loc2_) >>> 8 - 5 % 8));
         }
         param1.writeDouble(this.samples);
         param1.writeShort(0xFFFF & ((0xFFFF & this.energy_cost) >>> 13 % 16 | (0xFFFF & this.energy_cost) << 16 - 13 % 16));
         param1.writeBoolean(this.spinOnSale);
         param1.writeDouble(this.money);
         param1.writeByte(this.gates.length);
         for each(_loc3_ in this.gates)
         {
            _loc3_.write(param1);
         }
         param1.writeBoolean(this.galaxyGateDay);
      }
   }
}

