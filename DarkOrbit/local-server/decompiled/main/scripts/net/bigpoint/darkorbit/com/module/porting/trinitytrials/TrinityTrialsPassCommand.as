package net.bigpoint.darkorbit.com.module.porting.trinitytrials
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.darkorbit.com.module.porting.passevent.PassEventCommand;
   import net.bigpoint.darkorbit.com.module.porting.passevent.PassItemModule;
   
   public class TrinityTrialsPassCommand extends PassEventCommand
   {
      
      private static var _instance:TrinityTrialsPassCommand;
      
      public function TrinityTrialsPassCommand(param1:Boolean = false, param2:int = 0, param3:int = 0, param4:int = 0, param5:int = 0, param6:Vector.<PassItemModule> = null, param7:Vector.<PassItemModule> = null, param8:Vector.<int> = null)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8);
      }
      
      public static function get instance() : TrinityTrialsPassCommand
      {
         return _instance || (_instance = new TrinityTrialsPassCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -14347;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-14347);
         super.write(param1);
      }
   }
}

