package net.bigpoint.darkorbit.mvc.gui.windows.expedition.mediator.tab
{
   import net.bigpoint.darkorbit.Hero;
   import net.bigpoint.darkorbit.com.module.porting.expedition.ExpeditionRankUserInfoCommand;
   import net.bigpoint.darkorbit.fui.components.core.data.VectorCollection;
   import net.bigpoint.darkorbit.mvc.application.GameFacade;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.interfaces.IWindow;
   import net.bigpoint.darkorbit.mvc.gui.windows.common.mediator.SimpleWindowMediator;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.model.ExpeditionInfoProxy;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.ExpeditionInfoTabView4;
   import net.bigpoint.darkorbit.mvc.gui.windows.expedition.view.tab.itemRenderer.Tab4ListItemRenderer;
   import net.bigpoint.darkorbit.utils.time.TimeUtils;
   
   public class ExpeditionInfoTabMediator4 extends SimpleWindowMediator
   {
      
      private var _view:ExpeditionInfoTabView4;
      
      private var _proxy:ExpeditionInfoProxy;
      
      public function ExpeditionInfoTabMediator4(param1:String, param2:IWindow)
      {
         super(param1,param2);
         this._proxy = ExpeditionInfoProxy.getProxy(GameFacade.getInstance());
         this._proxy.viewData.change.addOnce(this.update);
      }
      
      public function setView(param1:ExpeditionInfoTabView4) : void
      {
         this._view = param1;
         this._view.rank_list.itemDataAssigner = Tab4ListItemRenderer;
         this.update();
      }
      
      public function update() : void
      {
         var _loc2_:String = null;
         if(!this._view || !this._proxy.viewData.infoCommand)
         {
            return;
         }
         var _loc1_:ExpeditionRankUserInfoCommand = this._proxy.viewData.getRankByUser();
         this._view.rank_list.list = new VectorCollection(this._proxy.viewData.infoCommand.ranks);
         this._view.self_rank_label.text = _loc1_ == null ? "--" : _loc1_.rank + "";
         this._view.self_name_label.text = Hero.username;
         this._view.self_level_label.text = _loc1_ == null ? "--" : _loc1_.curLevel + "";
         if(_loc1_)
         {
            _loc2_ = TimeUtils.formatTimeMinutes(_loc1_.clearanceTime);
         }
         this._view.self_time_label.text = _loc1_ == null ? "--" : _loc2_;
      }
      
      private function testData() : *
      {
         return JSON.parse("    [\n" + "        {\n" + "            \"rank\": 1,\n" + "            \"userId\": 456,\n" + "            \"userName\": \"yan019\",\n" + "            \"curLevel\": 45,\n" + "            \"clearanceTime\": 55\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 2,\n" + "            \"userId\": 437,\n" + "            \"userName\": \"ww12\",\n" + "            \"curLevel\": 41,\n" + "            \"clearanceTime\": 270\n" + "        },\n" + "        {\n" + "            \"rank\": 3,\n" + "            \"userId\": 234,\n" + "            \"userName\": \"TEST002\",\n" + "            \"curLevel\": 23,\n" + "            \"clearanceTime\": 27\n" + "        },\n" + "        {\n" + "            \"rank\": 4,\n" + "            \"userId\": 139,\n" + "            \"userName\": \"qq1\",\n" + "            \"curLevel\": 5,\n" + "            \"clearanceTime\": 5\n" + "        }\n" + "    ]");
      }
   }
}

