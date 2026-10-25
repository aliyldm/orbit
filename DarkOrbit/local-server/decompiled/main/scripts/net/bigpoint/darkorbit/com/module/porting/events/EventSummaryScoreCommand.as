package net.bigpoint.darkorbit.com.module.porting.events
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.FactionModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class EventSummaryScoreCommand implements IModule
   {
      
      private static var _instance:EventSummaryScoreCommand;
      
      public var score:Number = 0;
      
      public var factionModule:FactionModule;
      
      public function EventSummaryScoreCommand(param1:FactionModule = null, param2:Number = 0)
      {
         super();
         this.score = param2;
         if(param1 == null)
         {
            this.factionModule = new FactionModule();
         }
         else
         {
            this.factionModule = param1;
         }
      }
      
      public static function get instance() : EventSummaryScoreCommand
      {
         return _instance || (_instance = new EventSummaryScoreCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3106;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.score = param1.readDouble();
         this.factionModule = FactionModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.factionModule)
         {
            this.factionModule.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3106);
         param1.writeDouble(this.score);
         if(null != this.factionModule)
         {
            this.factionModule.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

