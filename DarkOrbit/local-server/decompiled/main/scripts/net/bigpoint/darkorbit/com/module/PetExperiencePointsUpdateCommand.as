package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PetExperiencePointsUpdateCommand implements IModule
   {
      
      private static var _instance:PetExperiencePointsUpdateCommand;
      
      public var currentExperiencePoints:Number = 0;
      
      public var maxExperiencePoints:Number = 0;
      
      public function PetExperiencePointsUpdateCommand(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.currentExperiencePoints = param1;
         this.maxExperiencePoints = param2;
      }
      
      public static function get instance() : PetExperiencePointsUpdateCommand
      {
         return _instance || (_instance = new PetExperiencePointsUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 159;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.currentExperiencePoints = param1.readDouble();
         this.maxExperiencePoints = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(159);
         param1.writeDouble(this.currentExperiencePoints);
         param1.writeDouble(this.maxExperiencePoints);
      }
   }
}

