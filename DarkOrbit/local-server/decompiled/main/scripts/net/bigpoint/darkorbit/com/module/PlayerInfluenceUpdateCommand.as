package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PlayerInfluenceUpdateCommand implements IModule
   {
      
      private static var _instance:PlayerInfluenceUpdateCommand;
      
      public var playerScore:Number = 0;
      
      public function PlayerInfluenceUpdateCommand(param1:Number = 0)
      {
         super();
         this.playerScore = param1;
      }
      
      public static function get instance() : PlayerInfluenceUpdateCommand
      {
         return _instance || (_instance = new PlayerInfluenceUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22034;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.playerScore = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-22034);
         param1.writeDouble(this.playerScore);
      }
   }
}

