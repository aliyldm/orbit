package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TeamDeathMatchErrorCommand implements IModule
   {
      
      private static var _instance:TeamDeathMatchErrorCommand;
      
      public static const ERRORTYPE_LEVEL_TOO_LOW:int = 0;
      
      public static const ERRORTYPE_QUEUE_FULL:int = 1;
      
      public static const ERRORTYPE_NO_MATCH_FOR_FACTION:int = 2;
      
      public static const ERRORTYPE_MATCH_ENDED:int = 3;
      
      public static const ERRORTYPE__MAX:int = 4;
      
      public var errorType:int = 0;
      
      public function TeamDeathMatchErrorCommand(param1:int = 0)
      {
         super();
         this.errorType = param1;
      }
      
      public static function get instance() : TeamDeathMatchErrorCommand
      {
         return _instance || (_instance = new TeamDeathMatchErrorCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 9131;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.errorType = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(9131);
         param1.writeShort(this.errorType);
      }
   }
}

