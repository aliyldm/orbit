package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class SpacePlagueStatusCommand implements IModule
   {
      
      private static var _instance:SpacePlagueStatusCommand;
      
      public var infection:SpacePlagueInfectionStatusCommand;
      
      public var bossSummoningInfos:Vector.<SpacePlagueBossSummoningProgressCommand>;
      
      public var rating:SpacePlagueRatingStatusCommand;
      
      public function SpacePlagueStatusCommand(param1:SpacePlagueInfectionStatusCommand = null, param2:SpacePlagueRatingStatusCommand = null, param3:Vector.<SpacePlagueBossSummoningProgressCommand> = null)
      {
         super();
         if(param1 == null)
         {
            this.infection = new SpacePlagueInfectionStatusCommand();
         }
         else
         {
            this.infection = param1;
         }
         if(param3 == null)
         {
            this.bossSummoningInfos = new Vector.<SpacePlagueBossSummoningProgressCommand>();
         }
         else
         {
            this.bossSummoningInfos = param3;
         }
         if(param2 == null)
         {
            this.rating = new SpacePlagueRatingStatusCommand();
         }
         else
         {
            this.rating = param2;
         }
      }
      
      public static function get instance() : SpacePlagueStatusCommand
      {
         return _instance || (_instance = new SpacePlagueStatusCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6926;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:SpacePlagueBossSummoningProgressCommand = null;
         this.infection = SpacePlagueInfectionStatusCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.infection)
         {
            this.infection.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.bossSummoningInfos.length > 0)
         {
            this.bossSummoningInfos.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = SpacePlagueBossSummoningProgressCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.bossSummoningInfos.push(_loc4_);
            _loc2_++;
         }
         this.rating = SpacePlagueRatingStatusCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.rating)
         {
            this.rating.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:SpacePlagueBossSummoningProgressCommand = null;
         param1.writeShort(6926);
         if(null != this.infection)
         {
            this.infection.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.bossSummoningInfos.length);
         for each(_loc2_ in this.bossSummoningInfos)
         {
            _loc2_.write(param1);
         }
         if(null != this.rating)
         {
            this.rating.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

