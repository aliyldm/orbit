package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SpacePlagueInfectionStatusCommand implements IModule
   {
      
      private static var _instance:SpacePlagueInfectionStatusCommand;
      
      public var infected:Boolean = false;
      
      public var remainingTime:int = 0;
      
      public function SpacePlagueInfectionStatusCommand(param1:Boolean = false, param2:int = 0)
      {
         super();
         this.infected = param1;
         this.remainingTime = param2;
      }
      
      public static function get instance() : SpacePlagueInfectionStatusCommand
      {
         return _instance || (_instance = new SpacePlagueInfectionStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -6245;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.infected = param1.readBoolean();
         this.remainingTime = param1.readInt();
         this.remainingTime = this.remainingTime >>> 16 % 32 | this.remainingTime << 32 - 16 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-6245);
         param1.writeBoolean(this.infected);
         param1.writeInt(this.remainingTime << 16 % 32 | this.remainingTime >>> 32 - 16 % 32);
      }
   }
}

