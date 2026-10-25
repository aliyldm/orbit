package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SpacePlagueRatingStatusCommand implements IModule
   {
      
      private static var _instance:SpacePlagueRatingStatusCommand;
      
      public var healthyPoints:int = 0;
      
      public var infectedPoints:int = 0;
      
      public function SpacePlagueRatingStatusCommand(param1:int = 0, param2:int = 0)
      {
         super();
         this.healthyPoints = param1;
         this.infectedPoints = param2;
      }
      
      public static function get instance() : SpacePlagueRatingStatusCommand
      {
         return _instance || (_instance = new SpacePlagueRatingStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 316;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.healthyPoints = param1.readInt();
         this.healthyPoints = this.healthyPoints << 7 % 32 | this.healthyPoints >>> 32 - 7 % 32;
         this.infectedPoints = param1.readInt();
         this.infectedPoints = this.infectedPoints >>> 3 % 32 | this.infectedPoints << 32 - 3 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(316);
         param1.writeInt(this.healthyPoints >>> 7 % 32 | this.healthyPoints << 32 - 7 % 32);
         param1.writeInt(this.infectedPoints << 3 % 32 | this.infectedPoints >>> 32 - 3 % 32);
      }
   }
}

