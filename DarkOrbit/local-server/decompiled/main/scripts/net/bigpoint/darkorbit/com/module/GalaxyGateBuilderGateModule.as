package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class GalaxyGateBuilderGateModule implements IModule
   {
      
      private static var _instance:GalaxyGateBuilderGateModule;
      
      public static const GATESTATE_IN_PROGRESS:int = 0;
      
      public static const GATESTATE_FINISHED:int = 1;
      
      public static const GATESTATE__MAX:int = 2;
      
      public var bonusGGRewardModules:Vector.<GalaxyGateBuilderBonusGGRewardModule>;
      
      public var currWave:int = 0;
      
      public var mode:String = "";
      
      public var currPart:int = 0;
      
      public var boosts:Vector.<GalaxyGateBuilderItemModule>;
      
      public var state:int = 0;
      
      public var probabilityModules:Vector.<GalaxyGateBuilderProbabilityModule>;
      
      public var lifePrice:int = 0;
      
      public var id:int = 0;
      
      public var multiplier:int = 0;
      
      public var multiGateProgressModules:Vector.<GalaxyGateBuilderMultiGateProgressModule>;
      
      public var livesLeft:int = 0;
      
      public function GalaxyGateBuilderGateModule(param1:String = "", param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:Vector.<GalaxyGateBuilderMultiGateProgressModule> = null, param10:Vector.<GalaxyGateBuilderBonusGGRewardModule> = null, param11:Vector.<GalaxyGateBuilderProbabilityModule> = null, param12:Vector.<GalaxyGateBuilderItemModule> = null)
      {
         super();
         if(param10 == null)
         {
            this.bonusGGRewardModules = new Vector.<GalaxyGateBuilderBonusGGRewardModule>();
         }
         else
         {
            this.bonusGGRewardModules = param10;
         }
         this.currWave = param7;
         this.mode = param1;
         this.currPart = param3;
         if(param12 == null)
         {
            this.boosts = new Vector.<GalaxyGateBuilderItemModule>();
         }
         else
         {
            this.boosts = param12;
         }
         this.state = param4;
         if(param11 == null)
         {
            this.probabilityModules = new Vector.<GalaxyGateBuilderProbabilityModule>();
         }
         else
         {
            this.probabilityModules = param11;
         }
         this.lifePrice = param6;
         this.id = param2;
         this.multiplier = param8;
         if(param9 == null)
         {
            this.multiGateProgressModules = new Vector.<GalaxyGateBuilderMultiGateProgressModule>();
         }
         else
         {
            this.multiGateProgressModules = param9;
         }
         this.livesLeft = param5;
      }
      
      public static function get instance() : GalaxyGateBuilderGateModule
      {
         return _instance || (_instance = new GalaxyGateBuilderGateModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 27276;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 32;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:GalaxyGateBuilderBonusGGRewardModule = null;
         var _loc5_:GalaxyGateBuilderItemModule = null;
         var _loc6_:GalaxyGateBuilderProbabilityModule = null;
         var _loc7_:GalaxyGateBuilderMultiGateProgressModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.bonusGGRewardModules.length > 0)
         {
            this.bonusGGRewardModules.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = GalaxyGateBuilderBonusGGRewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.bonusGGRewardModules.push(_loc4_);
            _loc2_++;
         }
         this.currWave = param1.readShort();
         this.currWave = 0xFFFF & ((0xFFFF & this.currWave) << 10 % 16 | (0xFFFF & this.currWave) >>> 16 - 10 % 16);
         this.currWave = this.currWave > 32767 ? int(this.currWave - 65536) : this.currWave;
         this.mode = param1.readUTF();
         this.currPart = param1.readShort();
         this.currPart = 0xFFFF & ((0xFFFF & this.currPart) >>> 10 % 16 | (0xFFFF & this.currPart) << 16 - 10 % 16);
         this.currPart = this.currPart > 32767 ? int(this.currPart - 65536) : this.currPart;
         while(this.boosts.length > 0)
         {
            this.boosts.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = GalaxyGateBuilderItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.boosts.push(_loc5_);
            _loc2_++;
         }
         this.state = param1.readShort();
         while(this.probabilityModules.length > 0)
         {
            this.probabilityModules.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = GalaxyGateBuilderProbabilityModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.probabilityModules.push(_loc6_);
            _loc2_++;
         }
         this.lifePrice = param1.readInt();
         this.lifePrice = this.lifePrice >>> 7 % 32 | this.lifePrice << 32 - 7 % 32;
         this.id = param1.readByte();
         this.id = 0xFF & ((0xFF & this.id) << 4 % 8 | (0xFF & this.id) >>> 8 - 4 % 8);
         this.id = this.id > 127 ? int(this.id - 256) : this.id;
         this.multiplier = param1.readByte();
         this.multiplier = 0xFF & ((0xFF & this.multiplier) << 2 % 8 | (0xFF & this.multiplier) >>> 8 - 2 % 8);
         this.multiplier = this.multiplier > 127 ? int(this.multiplier - 256) : this.multiplier;
         while(this.multiGateProgressModules.length > 0)
         {
            this.multiGateProgressModules.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc7_ = GalaxyGateBuilderMultiGateProgressModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc7_.read(param1);
            this.multiGateProgressModules.push(_loc7_);
            _loc2_++;
         }
         this.livesLeft = param1.readInt();
         this.livesLeft = this.livesLeft << 8 % 32 | this.livesLeft >>> 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:GalaxyGateBuilderBonusGGRewardModule = null;
         var _loc3_:GalaxyGateBuilderItemModule = null;
         var _loc4_:GalaxyGateBuilderProbabilityModule = null;
         var _loc5_:GalaxyGateBuilderMultiGateProgressModule = null;
         param1.writeShort(27276);
         param1.writeByte(this.bonusGGRewardModules.length);
         for each(_loc2_ in this.bonusGGRewardModules)
         {
            _loc2_.write(param1);
         }
         param1.writeShort(0xFFFF & ((0xFFFF & this.currWave) >>> 10 % 16 | (0xFFFF & this.currWave) << 16 - 10 % 16));
         param1.writeUTF(this.mode);
         param1.writeShort(0xFFFF & ((0xFFFF & this.currPart) << 10 % 16 | (0xFFFF & this.currPart) >>> 16 - 10 % 16));
         param1.writeByte(this.boosts.length);
         for each(_loc3_ in this.boosts)
         {
            _loc3_.write(param1);
         }
         param1.writeShort(this.state);
         param1.writeByte(this.probabilityModules.length);
         for each(_loc4_ in this.probabilityModules)
         {
            _loc4_.write(param1);
         }
         param1.writeInt(this.lifePrice << 7 % 32 | this.lifePrice >>> 32 - 7 % 32);
         param1.writeByte(0xFF & ((0xFF & this.id) >>> 4 % 8 | (0xFF & this.id) << 8 - 4 % 8));
         param1.writeByte(0xFF & ((0xFF & this.multiplier) >>> 2 % 8 | (0xFF & this.multiplier) << 8 - 2 % 8));
         param1.writeByte(this.multiGateProgressModules.length);
         for each(_loc5_ in this.multiGateProgressModules)
         {
            _loc5_.write(param1);
         }
         param1.writeInt(this.livesLeft >>> 8 % 32 | this.livesLeft << 32 - 8 % 32);
      }
   }
}

