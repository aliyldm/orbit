package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExpeditionShipCommand implements IModule
   {
      
      private static var _instance:ExpeditionShipCommand;
      
      public var hangarId:Number = 0;
      
      public var generators:int = 0;
      
      public var maxNano:int = 0;
      
      public var nano:int = 0;
      
      public var maxShield:int = 0;
      
      public var extras:int = 0;
      
      public var hp:int = 0;
      
      public var modules:int = 0;
      
      public var destroyed:Boolean = false;
      
      public var lootId:String = "";
      
      public var shield:int = 0;
      
      public var maxHp:int = 0;
      
      public var lasers:int = 0;
      
      public var rockets:int = 0;
      
      public function ExpeditionShipCommand(param1:Number = 0, param2:String = "", param3:int = 0, param4:int = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:int = 0, param12:int = 0, param13:int = 0, param14:Boolean = false)
      {
         super();
         this.hangarId = param1;
         this.generators = param11;
         this.maxNano = param7;
         this.nano = param8;
         this.maxShield = param5;
         this.extras = param12;
         this.hp = param4;
         this.modules = param13;
         this.destroyed = param14;
         this.lootId = param2;
         this.shield = param6;
         this.maxHp = param3;
         this.lasers = param9;
         this.rockets = param10;
      }
      
      public static function get instance() : ExpeditionShipCommand
      {
         return _instance || (_instance = new ExpeditionShipCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 20226;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 55;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.hangarId = param1.readDouble();
         this.generators = param1.readInt();
         this.generators = this.generators >>> 13 % 32 | this.generators << 32 - 13 % 32;
         this.maxNano = param1.readInt();
         this.maxNano = this.maxNano << 9 % 32 | this.maxNano >>> 32 - 9 % 32;
         this.nano = param1.readInt();
         this.nano = this.nano >>> 12 % 32 | this.nano << 32 - 12 % 32;
         this.maxShield = param1.readInt();
         this.maxShield = this.maxShield >>> 13 % 32 | this.maxShield << 32 - 13 % 32;
         this.extras = param1.readInt();
         this.extras = this.extras >>> 10 % 32 | this.extras << 32 - 10 % 32;
         this.hp = param1.readInt();
         this.hp = this.hp << 5 % 32 | this.hp >>> 32 - 5 % 32;
         this.modules = param1.readInt();
         this.modules = this.modules << 9 % 32 | this.modules >>> 32 - 9 % 32;
         this.destroyed = param1.readBoolean();
         this.lootId = param1.readUTF();
         this.shield = param1.readInt();
         this.shield = this.shield >>> 6 % 32 | this.shield << 32 - 6 % 32;
         this.maxHp = param1.readInt();
         this.maxHp = this.maxHp << 6 % 32 | this.maxHp >>> 32 - 6 % 32;
         this.lasers = param1.readInt();
         this.lasers = this.lasers >>> 13 % 32 | this.lasers << 32 - 13 % 32;
         this.rockets = param1.readInt();
         this.rockets = this.rockets >>> 3 % 32 | this.rockets << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(20226);
         param1.writeDouble(this.hangarId);
         param1.writeInt(this.generators << 13 % 32 | this.generators >>> 32 - 13 % 32);
         param1.writeInt(this.maxNano >>> 9 % 32 | this.maxNano << 32 - 9 % 32);
         param1.writeInt(this.nano << 12 % 32 | this.nano >>> 32 - 12 % 32);
         param1.writeInt(this.maxShield << 13 % 32 | this.maxShield >>> 32 - 13 % 32);
         param1.writeInt(this.extras << 10 % 32 | this.extras >>> 32 - 10 % 32);
         param1.writeInt(this.hp >>> 5 % 32 | this.hp << 32 - 5 % 32);
         param1.writeInt(this.modules >>> 9 % 32 | this.modules << 32 - 9 % 32);
         param1.writeBoolean(this.destroyed);
         param1.writeUTF(this.lootId);
         param1.writeInt(this.shield << 6 % 32 | this.shield >>> 32 - 6 % 32);
         param1.writeInt(this.maxHp >>> 6 % 32 | this.maxHp << 32 - 6 % 32);
         param1.writeInt(this.lasers << 13 % 32 | this.lasers >>> 32 - 13 % 32);
         param1.writeInt(this.rockets << 3 % 32 | this.rockets >>> 32 - 3 % 32);
      }
   }
}

