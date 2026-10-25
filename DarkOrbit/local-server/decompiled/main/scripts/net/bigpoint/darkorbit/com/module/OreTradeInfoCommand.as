package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class OreTradeInfoCommand implements IModule
   {
      
      private static var _instance:OreTradeInfoCommand;
      
      public static const TRADETYPE_INACTIVE:int = 0;
      
      public static const TRADETYPE_SPACE_STATION:int = 1;
      
      public static const TRADETYPE_DRONE:int = 2;
      
      public static const TRADETYPE_PET:int = 3;
      
      public static const TRADETYPE_BATTLE_STATION:int = 4;
      
      public static const TRADETYPE_PIRATE_STATION:int = 5;
      
      public static const TRADETYPE_GROUP_GATE_STATION:int = 6;
      
      public static const TRADETYPE__MAX:int = 7;
      
      public var sepromPrice:int = 0;
      
      public var terbiumPrice:int = 0;
      
      public var duraniumPrice:int = 0;
      
      public var palladiumExchangeRate:int = 0;
      
      public var enduriumPrice:int = 0;
      
      public var osmiumPrice:int = 0;
      
      public var promeriumPrice:int = 0;
      
      public var type:int = 0;
      
      public var prometiumPrice:int = 0;
      
      public var remainingCharges:int = 0;
      
      public var prometidPrice:int = 0;
      
      public function OreTradeInfoCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:int = 0)
      {
         super();
         this.sepromPrice = param9;
         this.terbiumPrice = param5;
         this.duraniumPrice = param7;
         this.palladiumExchangeRate = param10;
         this.enduriumPrice = param4;
         this.osmiumPrice = param11;
         this.promeriumPrice = param8;
         this.type = param1;
         this.prometiumPrice = param3;
         this.remainingCharges = param2;
         this.prometidPrice = param6;
      }
      
      public static function get instance() : OreTradeInfoCommand
      {
         return _instance || (_instance = new OreTradeInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 1870;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 40;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.sepromPrice = param1.readInt();
         this.sepromPrice = this.sepromPrice << 10 % 32 | this.sepromPrice >>> 32 - 10 % 32;
         this.terbiumPrice = param1.readInt();
         this.terbiumPrice = this.terbiumPrice << 4 % 32 | this.terbiumPrice >>> 32 - 4 % 32;
         this.duraniumPrice = param1.readInt();
         this.duraniumPrice = this.duraniumPrice >>> 12 % 32 | this.duraniumPrice << 32 - 12 % 32;
         this.palladiumExchangeRate = param1.readInt();
         this.palladiumExchangeRate = this.palladiumExchangeRate << 13 % 32 | this.palladiumExchangeRate >>> 32 - 13 % 32;
         this.enduriumPrice = param1.readInt();
         this.enduriumPrice = this.enduriumPrice >>> 16 % 32 | this.enduriumPrice << 32 - 16 % 32;
         this.osmiumPrice = param1.readInt();
         this.osmiumPrice = this.osmiumPrice >>> 11 % 32 | this.osmiumPrice << 32 - 11 % 32;
         this.promeriumPrice = param1.readInt();
         this.promeriumPrice = this.promeriumPrice << 11 % 32 | this.promeriumPrice >>> 32 - 11 % 32;
         this.type = param1.readShort();
         this.prometiumPrice = param1.readInt();
         this.prometiumPrice = this.prometiumPrice >>> 15 % 32 | this.prometiumPrice << 32 - 15 % 32;
         this.remainingCharges = param1.readInt();
         this.remainingCharges = this.remainingCharges << 2 % 32 | this.remainingCharges >>> 32 - 2 % 32;
         this.prometidPrice = param1.readInt();
         this.prometidPrice = this.prometidPrice >>> 7 % 32 | this.prometidPrice << 32 - 7 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(1870);
         param1.writeInt(this.sepromPrice >>> 10 % 32 | this.sepromPrice << 32 - 10 % 32);
         param1.writeInt(this.terbiumPrice >>> 4 % 32 | this.terbiumPrice << 32 - 4 % 32);
         param1.writeInt(this.duraniumPrice << 12 % 32 | this.duraniumPrice >>> 32 - 12 % 32);
         param1.writeInt(this.palladiumExchangeRate >>> 13 % 32 | this.palladiumExchangeRate << 32 - 13 % 32);
         param1.writeInt(this.enduriumPrice << 16 % 32 | this.enduriumPrice >>> 32 - 16 % 32);
         param1.writeInt(this.osmiumPrice << 11 % 32 | this.osmiumPrice >>> 32 - 11 % 32);
         param1.writeInt(this.promeriumPrice >>> 11 % 32 | this.promeriumPrice << 32 - 11 % 32);
         param1.writeShort(this.type);
         param1.writeInt(this.prometiumPrice << 15 % 32 | this.prometiumPrice >>> 32 - 15 % 32);
         param1.writeInt(this.remainingCharges >>> 2 % 32 | this.remainingCharges << 32 - 2 % 32);
         param1.writeInt(this.prometidPrice << 7 % 32 | this.prometidPrice >>> 32 - 7 % 32);
      }
   }
}

