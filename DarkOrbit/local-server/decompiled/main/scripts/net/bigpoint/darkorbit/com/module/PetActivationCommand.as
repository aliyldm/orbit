package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetActivationCommand implements IModule
   {
      
      private static var _instance:PetActivationCommand;
      
      public var ownerId:int = 0;
      
      public var petId:int = 0;
      
      public var petDesignId:int = 0;
      
      public var expansionStage:int = 0;
      
      public var petName:String = "";
      
      public var petFactionId:int = 0;
      
      public var petClanID:int = 0;
      
      public var petLevel:int = 0;
      
      public var clanTag:String = "";
      
      public var clanRelationship:ClanRelationModule;
      
      public var x:int = 0;
      
      public var y:int = 0;
      
      public var petSpeed:int = 0;
      
      public var isInIdleMode:Boolean = false;
      
      public var isVisible:Boolean = false;
      
      public var minimapStrategyModule:MinimapStrategyModule;
      
      public function PetActivationCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:int = 0, param5:String = "", param6:int = 0, param7:int = 0, param8:int = 0, param9:String = "", param10:ClanRelationModule = null, param11:int = 0, param12:int = 0, param13:int = 0, param14:Boolean = false, param15:Boolean = false, param16:MinimapStrategyModule = null)
      {
         super();
         this.ownerId = param1;
         this.petId = param2;
         this.petDesignId = param3;
         this.expansionStage = param4;
         this.petName = param5;
         this.petFactionId = param6;
         this.petClanID = param7;
         this.petLevel = param8;
         this.clanTag = param9;
         if(param10 == null)
         {
            this.clanRelationship = new ClanRelationModule();
         }
         else
         {
            this.clanRelationship = param10;
         }
         this.x = param11;
         this.y = param12;
         this.petSpeed = param13;
         this.isInIdleMode = param14;
         this.isVisible = param15;
         if(param16 == null)
         {
            this.minimapStrategyModule = new MinimapStrategyModule();
         }
         else
         {
            this.minimapStrategyModule = param16;
         }
      }
      
      public static function get instance() : PetActivationCommand
      {
         return _instance || (_instance = new PetActivationCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 232;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 38;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.ownerId = param1.readInt();
         this.ownerId = this.ownerId << 7 % 32 | this.ownerId >>> 32 - 7 % 32;
         this.petId = param1.readInt();
         this.petId = this.petId >>> 11 % 32 | this.petId << 32 - 11 % 32;
         this.petDesignId = param1.readShort();
         this.petDesignId = 0xFFFF & ((0xFFFF & this.petDesignId) << 13 % 16 | (0xFFFF & this.petDesignId) >>> 16 - 13 % 16);
         this.petDesignId = this.petDesignId > 32767 ? int(this.petDesignId - 65536) : this.petDesignId;
         this.expansionStage = param1.readShort();
         this.expansionStage = 0xFFFF & ((0xFFFF & this.expansionStage) << 6 % 16 | (0xFFFF & this.expansionStage) >>> 16 - 6 % 16);
         this.expansionStage = this.expansionStage > 32767 ? int(this.expansionStage - 65536) : this.expansionStage;
         this.petName = param1.readUTF();
         this.petFactionId = param1.readShort();
         this.petFactionId = 0xFFFF & ((0xFFFF & this.petFactionId) >>> 5 % 16 | (0xFFFF & this.petFactionId) << 16 - 5 % 16);
         this.petFactionId = this.petFactionId > 32767 ? int(this.petFactionId - 65536) : this.petFactionId;
         this.petClanID = param1.readInt();
         this.petClanID = this.petClanID << 14 % 32 | this.petClanID >>> 32 - 14 % 32;
         this.petLevel = param1.readShort();
         this.petLevel = 0xFFFF & ((0xFFFF & this.petLevel) >>> 8 % 16 | (0xFFFF & this.petLevel) << 16 - 8 % 16);
         this.petLevel = this.petLevel > 32767 ? int(this.petLevel - 65536) : this.petLevel;
         this.clanTag = param1.readUTF();
         this.clanRelationship = ClanRelationModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.clanRelationship)
         {
            this.clanRelationship.read(param1);
         }
         this.x = param1.readInt();
         this.x = this.x << 2 % 32 | this.x >>> 32 - 2 % 32;
         this.y = param1.readInt();
         this.y = this.y >>> 5 % 32 | this.y << 32 - 5 % 32;
         this.petSpeed = param1.readInt();
         this.petSpeed = this.petSpeed << 11 % 32 | this.petSpeed >>> 32 - 11 % 32;
         this.isInIdleMode = param1.readBoolean();
         this.isVisible = param1.readBoolean();
         this.minimapStrategyModule = MinimapStrategyModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.minimapStrategyModule)
         {
            this.minimapStrategyModule.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(232);
         param1.writeInt(this.ownerId >>> 7 % 32 | this.ownerId << 32 - 7 % 32);
         param1.writeInt(this.petId << 11 % 32 | this.petId >>> 32 - 11 % 32);
         param1.writeShort(0xFFFF & ((0xFFFF & this.petDesignId) >>> 13 % 16 | (0xFFFF & this.petDesignId) << 16 - 13 % 16));
         param1.writeShort(0xFFFF & ((0xFFFF & this.expansionStage) >>> 6 % 16 | (0xFFFF & this.expansionStage) << 16 - 6 % 16));
         param1.writeUTF(this.petName);
         param1.writeShort(0xFFFF & ((0xFFFF & this.petFactionId) << 5 % 16 | (0xFFFF & this.petFactionId) >>> 16 - 5 % 16));
         param1.writeInt(this.petClanID >>> 14 % 32 | this.petClanID << 32 - 14 % 32);
         param1.writeShort(0xFFFF & ((0xFFFF & this.petLevel) << 8 % 16 | (0xFFFF & this.petLevel) >>> 16 - 8 % 16));
         param1.writeUTF(this.clanTag);
         if(null != this.clanRelationship)
         {
            this.clanRelationship.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeInt(this.x >>> 2 % 32 | this.x << 32 - 2 % 32);
         param1.writeInt(this.y << 5 % 32 | this.y >>> 32 - 5 % 32);
         param1.writeInt(this.petSpeed >>> 11 % 32 | this.petSpeed << 32 - 11 % 32);
         param1.writeBoolean(this.isInIdleMode);
         param1.writeBoolean(this.isVisible);
         if(null != this.minimapStrategyModule)
         {
            this.minimapStrategyModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

