package net.bigpoint.darkorbit.mvc.application.controller
{
   import net.bigpoint.darkorbit.bplocal.BPLocalLoadVO;
   import net.bigpoint.darkorbit.bplocal.BPLocalLoader;
   import net.bigpoint.darkorbit.bplocal.parser.BPLocaleParser4DO;
   import net.bigpoint.darkorbit.mvc.abstract.controller.DOAbstractAsyncCommand;
   
   public class DOAbstractLoadLanguagesAsyncCommand extends DOAbstractAsyncCommand
   {
      
      public function DOAbstractLoadLanguagesAsyncCommand()
      {
         super();
      }
      
      protected function loadLanguages(param1:Vector.<String>, param2:Vector.<String>, param3:Function) : void
      {
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc4_:Vector.<BPLocalLoadVO> = new Vector.<BPLocalLoadVO>();
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = param1[_loc5_];
            _loc7_ = param2[_loc5_] || "";
            _loc4_.push(new BPLocalLoadVO(_loc6_,_loc7_));
            _loc5_++;
         }
         this.load(_loc4_,param3);
      }
      
      private function load(param1:Vector.<BPLocalLoadVO>, param2:Function) : void
      {
         new BPLocalLoader().loaderMultipleURLs(param1,this.handleAllFilesLoaded,[param2]);
      }
      
      private function handleAllFilesLoaded(param1:Vector.<XML>, param2:Function = null) : void
      {
         var _loc3_:int = int(param1.length);
         var _loc4_:BPLocaleParser4DO = new BPLocaleParser4DO();
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_)
         {
            _loc4_.parseXML(param1[_loc5_]);
            _loc5_++;
         }
         param1.length = 0;
         if(param2 != null)
         {
            param2();
         }
      }
   }
}

