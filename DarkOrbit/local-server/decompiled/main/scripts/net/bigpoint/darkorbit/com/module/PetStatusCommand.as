package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetStatusCommand implements IModule
   {
      
      private static var _instance:PetStatusCommand;
      
      public var petId:int = 0;
      
      public var petLevel:int = 0;
      
      public var petExperiencePoints:Number = 0;
      
      public var petExperiencePointsUntilNextLevel:Number = 0;
      
      public var petHitPoints:int = 0;
      
      public var petHitPointsMax:int = 0;
      
      public var petShieldEnergyNow:int = 0;
      
      public var petShieldEnergyMax:int = 0;
      
      public var petCurrentFuel:int = 0;
      
      public var petMaxFuel:int = 0;
      
      public var petSpeed:int = 0;
      
      public var petName:String = "";
      
      public var petLootId:String = "";
      
      public function PetStatusCommand(param1:int = 0, param2:int = 0, param3:Number = 0, param4:Number = 0, param5:int = 0, param6:int = 0, param7:int = 0, param8:int = 0, param9:int = 0, param10:int = 0, param11:int = 0, param12:String = "", param13:String = "")
      {
         super();
         this.petId = param1;
         this.petLevel = param2;
         this.petExperiencePoints = param3;
         this.petExperiencePointsUntilNextLevel = param4;
         this.petHitPoints = param5;
         this.petHitPointsMax = param6;
         this.petShieldEnergyNow = param7;
         this.petShieldEnergyMax = param8;
         this.petCurrentFuel = param9;
         this.petMaxFuel = param10;
         this.petSpeed = param11;
         this.petName = param12;
         this.petLootId = param13;
      }
      
      public static function get instance() : PetStatusCommand
      {
         return _instance || (_instance = new PetStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 157;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 56;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.petId = param1.readInt();
         this.petId = this.petId >>> 11 % 32 | this.petId << 32 - 11 % 32;
         this.petLevel = param1.readInt();
         this.petLevel = this.petLevel << 5 % 32 | this.petLevel >>> 32 - 5 % 32;
         this.petExperiencePoints = param1.readDouble();
         this.petExperiencePointsUntilNextLevel = param1.readDouble();
         this.petHitPoints = param1.readInt();
         this.petHitPoints = this.petHitPoints << 12 % 32 | this.petHitPoints >>> 32 - 12 % 32;
         this.petHitPointsMax = param1.readInt();
         this.petHitPointsMax = this.petHitPointsMax >>> 5 % 32 | this.petHitPointsMax << 32 - 5 % 32;
         this.petShieldEnergyNow = param1.readInt();
         this.petShieldEnergyNow = this.petShieldEnergyNow << 13 % 32 | this.petShieldEnergyNow >>> 32 - 13 % 32;
         this.petShieldEnergyMax = param1.readInt();
         this.petShieldEnergyMax = this.petShieldEnergyMax << 2 % 32 | this.petShieldEnergyMax >>> 32 - 2 % 32;
         this.petCurrentFuel = param1.readInt();
         this.petCurrentFuel = this.petCurrentFuel << 4 % 32 | this.petCurrentFuel >>> 32 - 4 % 32;
         this.petMaxFuel = param1.readInt();
         this.petMaxFuel = this.petMaxFuel << 6 % 32 | this.petMaxFuel >>> 32 - 6 % 32;
         this.petSpeed = param1.readInt();
         this.petSpeed = this.petSpeed >>> 12 % 32 | this.petSpeed << 32 - 12 % 32;
         this.petName = param1.readUTF();
         this.petLootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(157);
         param1.writeInt(this.petId << 11 % 32 | this.petId >>> 32 - 11 % 32);
         param1.writeInt(this.petLevel >>> 5 % 32 | this.petLevel << 32 - 5 % 32);
         param1.writeDouble(this.petExperiencePoints);
         param1.writeDouble(this.petExperiencePointsUntilNextLevel);
         param1.writeInt(this.petHitPoints >>> 12 % 32 | this.petHitPoints << 32 - 12 % 32);
         param1.writeInt(this.petHitPointsMax << 5 % 32 | this.petHitPointsMax >>> 32 - 5 % 32);
         param1.writeInt(this.petShieldEnergyNow >>> 13 % 32 | this.petShieldEnergyNow << 32 - 13 % 32);
         param1.writeInt(this.petShieldEnergyMax >>> 2 % 32 | this.petShieldEnergyMax << 32 - 2 % 32);
         param1.writeInt(this.petCurrentFuel >>> 4 % 32 | this.petCurrentFuel << 32 - 4 % 32);
         param1.writeInt(this.petMaxFuel >>> 6 % 32 | this.petMaxFuel << 32 - 6 % 32);
         param1.writeInt(this.petSpeed << 12 % 32 | this.petSpeed >>> 32 - 12 % 32);
         param1.writeUTF(this.petName);
         param1.writeUTF(this.petLootId);
      }
   }
}

