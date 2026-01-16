pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
u={{name="small tent",level=1,slots=2,seats=100,cost=0},{name="medium tent",level=2,slots=4,seats=250,cost=1000},{name="large tent",level=3,slots=6,seats=500,cost=2000}}r={{id="clown",name="clown troupe",type="comedy",upkeep=50,cost=500,size=1},{id="juggler",name="fire juggler",type="danger",upkeep=80,cost=800,size=1},{id="elephants",name="elephant show",type="animal",upkeep=150,cost=1500,size=2},{id="acrobats",name="acrobat team",type="skill",upkeep=120,cost=1200,size=2},{id="lion",name="lion tamer",type="animal",upkeep=200,cost=2000,size=2},{id="magician",name="magician",type="skill",upkeep=100,cost=1000,size=1},{id="trapeze",name="trapeze",type="danger",upkeep=180,cost=1800,size=2},{id="contortionist",name="contortionist",type="skill",upkeep=90,cost=900,size=1},{id="strongman",name="strongman",type="danger",upkeep=110,cost=1100,size=1}}V={{id="storm",name="tent damage",description="a storm damaged your tent!",effect_type="money",effect_value=-200,is_positive=false},{id="celebrity",name="celebrity visit",description="a famous actor attended your show and posted about it!",effect_type="demand",effect_value=30,is_positive=true},{id="theft",name="equipment theft",description="thieves stole some of your equipment!",effect_type="money",effect_value=-150,is_positive=false},{id="review",name="glowing review",description="local newspaper gave you a glowing review!",effect_type="demand",effect_value=20,is_positive=true},{id="fire",name="small fire",description="a small fire damaged some property.",effect_type="money",effect_value=-200,is_positive=false},{id="contest",name="act wins contest",description="one of your acts won a regional contest!",effect_type="both",effect_value_money=100,effect_value_demand=15,is_positive=true},{id="inspection",name="safety inspection",description="failed a safety inspection! paid fine and repairs.",effect_type="money",effect_value=-175,is_positive=false},{id="viral",name="viral video",description="your show went viral on social media!",effect_type="both",effect_value_money=50,effect_value_demand=25,is_positive=true}}d={{id="frisco",name="frisco",population=1400,base_cost=100,favorites={"comedy","animal"},demand=100,price_sensitivity=.9,region="central"},{id="austin",name="austin",population=2000,base_cost=200,favorites={"danger","skill"},demand=50,price_sensitivity=1,region="central"},{id="chicago",name="chicago",population=5000,base_cost=500,favorites={"skill","comedy"},demand=50,price_sensitivity=1.2,region="central"},{id="denver",name="denver",population=1800,base_cost=180,favorites={"animal","danger"},demand=50,price_sensitivity=.95,region="west"},{id="seattle",name="seattle",population=3500,base_cost=350,favorites={"skill","comedy"},demand=50,price_sensitivity=1.1,region="west"},{id="miami",name="miami",population=2800,base_cost=250,favorites={"danger","comedy"},demand=50,price_sensitivity=1.05,region="east"},{id="boston",name="boston",population=3000,base_cost=300,favorites={"skill","animal"},demand=50,price_sensitivity=1.15,region="east"}}c={week=1,money=500,current_city="frisco",reputation=0,tent_level=1,ticket_price=5,owned_acts={{id="clown",skill=1}},previously_owned_acts={"clown"},selected_act_id=nil,selected_city_id=nil}function eo(e,n)for l=1,#e do if e[l]==n then return true end end return false end function h(n)for e=1,#r do if r[e].id==n then return r[e]end end return nil end function R(n)for e=1,#c.owned_acts do if c.owned_acts[e].id==n then return c.owned_acts[e]end end return nil end function l(n)for e=1,#d do if d[e].id==n then return d[e]end end return nil end function p(l,e)local n=e if btnp(2)then n=max(1,e-1)end if btnp(3)then n=min(l,e+1)end return n end function v()return dget(0)~=0end function A()return dget(41)>0end o="splash_screen"W=nil F={"run show","manage acts","manage tent","cities","save game","exit"}B,_,y,w,G,H,C,ea,I,D,ei,J=1,1,1,1,1,1,1,1,1,1,1,1k=1i={}K=false n=1a={total_cost=0,attendance=0,revenue=0,profit=0,pre_show_demand=100,price_factor=1,quality_score=1,fav_bonus=1,num_fav_matches=0,target_price=5,audience_feedback={}}L=1b=1f=nil g={}z=1function s()local e="$"..c.money local n=128-#e*4?e,n-2,5,11
if c.money<0and o~="game_over"and o~="season_end"then o="game_over"end if c.week>=30and o~="game_over"and o~="season_end"then o="season_end"end end function _init()cartdata"circus_tycoon_save"i={}for e=1,5do local e=dget(40+e)if e>0then add(i,e)end end music(0)end function _update()X()end function _draw()cls(1)X(true)end function X(e)if e==nil then e=false end if not e and W~="act_details"and o=="act_details"then w=1end if o=="splash_screen"then if not e then ed()else ec()end elseif o=="main_menu"then if not e then e1()else ef()end elseif o=="manage_acts"then if not e then er()else e0()end elseif o=="act_details"then if not e then es()else eh()end elseif o=="confirm_fire"then if not e then eu()else e5()end elseif o=="confirm_train"then if not e then em()else e2()end elseif o=="act_trained"then if not e then e_()else e8()end elseif o=="hire_acts"then if not e then e7()else eg()end elseif o=="hire_act_details"then if not e then e4()else ep()end elseif o=="confirm_hire"then if not e then e3()else ew()end elseif o=="manage_tent"then if not e then ey()else ev()end elseif o=="upgrade_tent"then if not e then e6()else ek()end elseif o=="confirm_upgrade"then if not e then eb()else e9()end elseif o=="run_show"then if not e then ez()else ex()end elseif o=="confirm_show"then if not e then ej()else eq()end elseif o=="show_results"then if not e then eA()else eB()end elseif o=="cities_list"then if not e then eC()else eD()end elseif o=="city_details"then if not e then eE()else eF()end elseif o=="confirm_travel"then if not e then eG()else eH()end elseif o=="random_event"then if not e then eI()else eJ()end elseif o=="act_level_up"then if not e then eK()else eL()end elseif o=="save_complete"then if not e then eM()else eN()end elseif o=="game_over"then if not e then eO()else eP()end elseif o=="season_end"then if not e then eQ()else eR()end elseif o=="high_scores"then if not e then eS()else eT()end end if not e then W=o end end function ed()local e=1if v()then e+=1end if A()then e+=1end _=p(e,_)if btnp(4)then if v()and _==1then eU()o="main_menu"elseif v()and A()and _==3then o="high_scores"n=1elseif A()and not v()and _==2then o="high_scores"n=1else c={week=1,money=500,current_city="frisco",reputation=0,tent_level=1,ticket_price=5,owned_acts={{id="clown",skill=1}},previously_owned_acts={"clown"},selected_act_id=nil,selected_city_id=nil}for e=1,#d do d[e].demand=d[e].id==c.current_city and 100or 50end Y()B=1o="main_menu"end end end function ec()map(0,0,0,0,16,16)spr(128,32,8,8,8)local n,e=1,0if v()then n,e=n+1,e+10end if A()then n,e=n+1,e+10end local e=e+15rectfill(25,70,103,70+e,0)rect(25,70,103,70+e,5)local e,n=75,1local function l(t)local l=_==n and 10or 7if _==n then?">",30,e,l
end?t,40,e,l
e+=10n+=1end if v()then l"resume game"end l"new game"if A()then l"high scores"end?"press 🅾️ to select",32,115,5
end function e1()B=p(#F,B)if btnp(4)then local e=F[B]if e=="exit"then o="splash_screen"_=1elseif e=="run show"then o="run_show"elseif e=="manage acts"then o="manage_acts"y=1elseif e=="manage tent"then o="manage_tent"C=1elseif e=="cities"then o="cities_list"D=1elseif e=="save game"then Y()o="save_complete"end end end function er()local e=#c.owned_acts+1y=p(e,y)if btnp(4)then if y<=#c.owned_acts then local e=c.owned_acts[y].id c.selected_act_id=e o="act_details"w=1else o="hire_acts"E=1end end if btnp(5)then o="main_menu"end end function es()if btnp(5)then c.selected_act_id=nil o="manage_acts"return end w=p(2,w)if btnp(4)then if w==1then local e=h(c.selected_act_id)local e=e.upkeep*2if c.money>=e then o="confirm_train"H=1return end elseif w==2then o="confirm_fire"G=1return end end end function eu()local e,n=function()local n=c.selected_act_id for e=1,#c.owned_acts do if c.owned_acts[e].id==n then deli(c.owned_acts,e)break end end c.selected_act_id=nil o="manage_acts"end,function()o="act_details"end G=x(e,n,G)end function em()local e,n=function()local e=c.selected_act_id local n,e=h(e),R(e)local n=n.upkeep*2if c.money>=n and e then c.money-=n local n=flr(e.skill)e.skill=min(5,e.skill+.15)local l=flr(e.skill)local n=l>n if n then g={}add(g,e)z=1o="act_level_up"else o="act_trained"end else o="act_details"end end,function()o="act_details"end H=x(e,n,H)end function e_()if btnp(5)or btnp(4)then o="act_details"end end function m(l,n,e)e=e or 22local t=n and 22or 12if e<t then e=t end rectfill(0,12,127,12+e,8)rectfill(0,13,127,11+e,12)local t=#l*4local t=64-t/2?l,t,16,7
if n then local e=#n*4local e=64-e/2?n,e,26,10
end return 12+e end function ef()local e=m("circus tycoon","week "..c.week.."/30",22)s()local n=e+10for e=1,#F do local l,n=n+(e-1)*10,6if e==B then n=10?">",25,l,n
end?F[e],35,l,n
end end function e0()s()local e=m("manage acts",nil,12)local l=e+10for e=1,#c.owned_acts do local n=c.owned_acts[e]local n,l,t,o=h(n.id),l+(e-1)*8,7,6if e==y then t=10o=10?">",5,l,t
end?n.name.." ",15,l,t
local e,n="(upkeep:$"..n.upkeep..")",#n.name*4?e,15+n+4,l,o
end local n,e=l+#c.owned_acts*8+4,7if y==#c.owned_acts+1then e=10?">",5,n,e
end?"hire new acts",15,n,e
end function S(n)local e=""for l=1,5do if l<=n then e=e.."●"else e=e.."○"end end return e end function eh()if c.selected_act_id==nil then return end local n,l=h(c.selected_act_id),R(c.selected_act_id)if n==nil or l==nil then return end s()local e=m("act details",nil,12)local e=e+10?"name:",10,e,6
?n.name,38,e,7
?"type:",10,e+8,6
?n.type,38,e+8,7
?"skill level:",10,e+16,6
?S(l.skill),62,e+16,10
?"upkeep:",10,e+24,6
?"$"..n.upkeep.."/week",46,e+24,7
?"size:",10,e+32,6
?n.size.." slot(s)",38,e+32,7
local l,n=e+48,n.upkeep*2local t=c.money>=n local o,t=t and 7or 5,t and 10or 6if w==1then?">",0,l,t
o=t end?"train act ($"..n..")",10,l,o
local e,n=e+64,7if w==2then n=10?">",0,e,10
end?"fire act",10,e,n
end function e5()if c.selected_act_id==nil then return end local e=h(c.selected_act_id)if e==nil then return end j("fire "..e.name.."?",nil,G,65)end function e2()if c.selected_act_id==nil then return end local e=h(c.selected_act_id)if e==nil then return end local n=e.upkeep*2s()j("train "..e.name.."?","cost: $"..n,H,65)end function e8()if c.selected_act_id==nil then return end local e,n=h(c.selected_act_id),R(c.selected_act_id)if e==nil or n==nil then return end local n=flr(n.skill)s()local l={"looking better!","improving steadily!","technique is better!"}local t=(n*5+#e.id)%#l+1local l=l[t]M("★ training complete! ★",e.name,n,l)end function T(e)for n=1,#c.owned_acts do if c.owned_acts[n].id==e then return true end end return false end function q()return u[c.tent_level]end function N()local e=0for n=1,#c.owned_acts do local n=h(c.owned_acts[n].id)e+=n.size end return e end function Z(e)return c.money>=e.cost end function ee(e)local n,l=q(),N()return l+e.size<=n.slots end function O(e)return Z(e)and ee(e)and not T(e.id)end E=1en=1P=1function e7()local e={}for n=1,#r do if not T(r[n].id)then add(e,r[n])end end local n=#e if n>0then E=p(n,E)end if btnp(4)and n>0then c.selected_act_id=e[E].id o="hire_act_details"en=1end if btnp(5)then o="manage_acts"end end function e4()if btnp(5)then c.selected_act_id=nil o="hire_acts"return end if btnp(4)then local e=h(c.selected_act_id)if e and O(e)then o="confirm_hire"P=1end end end function e3()local e,n=function()local e=c.selected_act_id local n=h(e)if n and O(n)then c.money-=n.cost add(c.owned_acts,{id=e,skill=1})local n=true for l=1,#c.previously_owned_acts do if c.previously_owned_acts[l]==e then n=false break end end if n then for e=1,#d do d[e].demand=min(100,d[e].demand+20)end add(c.previously_owned_acts,e)end end c.selected_act_id=nil o="manage_acts"end,function()o="hire_act_details"end P=x(e,n,P)end function eg()s()local n,e,l=m("hire new acts",nil,12),q(),N()?"tent slots: "..l.."/"..e.slots,10,n+5,7
local e={}for n=1,#r do if not T(r[n].id)then add(e,r[n])end end local l=n+20if#e==0then?"no available acts",15,l,7
else for n=1,#e do local e,t=e[n],l+(n-1)*10local o=O(e)local l=o and 7or 5if n==E then l=o and 10or 6?">",5,t,l
end?e.name.." ($"..e.cost..", "..e.size.." slot)",15,t,l
end end end function ep()if c.selected_act_id==nil then return end local e=h(c.selected_act_id)if e==nil then return end local l,t,o=O(e),q(),N()s()local n=m("hire: "..e.name,nil,12)local n=n+10?"type: "..e.type,10,n,7
?"upkeep: $"..e.upkeep.."/week",10,n+8,7
?"size: "..e.size.." slot(s)",10,n+16,7
?"starting skill: "..S(1),10,n+24,7
local a=o+e.size<=t.slots and 7or 8?"tent space: "..e.size.." (current: "..o.."/"..t.slots..")",10,n+40,a
local t=c.money>=e.cost and 7or 8?"hiring cost: $"..e.cost,10,n+56,t
local n,t=n+72,l and 7or 5if en==1then t=l and 10or 6?">",0,n,t
end?"hire act",10,n,t
if not l then local n=n+12if not ee(e)then?"need larger tent for this act",10,n,8
elseif not Z(e)then?"not enough money to hire",10,n,8
end end local e=l and 5or 6end function ew()if c.selected_act_id==nil then return end local e=h(c.selected_act_id)if e==nil then return end j("hire "..e.name.."?","cost: $"..e.cost,P,70)end function ey()C=p(1,C)if btnp(4)then if C==1then o="upgrade_tent"ea=1end end if btnp(5)then o="main_menu"end end function e6()local e=c.tent_level+1local n=e<=#u if btnp(4)and n then local e=u[e]if c.money>=e.cost then o="confirm_upgrade"I=1end end if btnp(5)then o="manage_tent"end end function eb()local e,n=function()local e=c.tent_level+1if e<=#u then local n=u[e]if c.money>=n.cost then c.money-=n.cost c.tent_level=e end end o="manage_tent"end,function()o="upgrade_tent"end I=x(e,n,I)end function ev()s()local n,e=m("manage tent",nil,12),u[c.tent_level]local n=n+10?"current tent: "..e.name,10,n,7
?"capacity: "..e.seats.." seats",10,n+10,7
local l=N()local t=l==e.slots and 8or 7?"act slots: "..l.."/"..e.slots,10,n+20,t
local e,n=n+40,c.tent_level<#u local l=n and 7or 5if C==1then l=n and 10or 6?">",5,e,l
end?"upgrade tent",10,e,l
if not n then?"maximum tent level reached",10,e+10,5
end?"🅾️: select",10,106,5
?"❎: back",80,106,5
end function ek()s()local e,l,n=m("upgrade tent",nil,12),u[c.tent_level],c.tent_level+1local e=e+10if n<=#u then local n=u[n]?"current: "..l.name,10,e,7
?"capacity: "..l.seats.." seats",10,e+8,7
?"act slots: "..l.slots,10,e+16,7
?"next: "..n.name,10,e+32,11
?"capacity: "..n.seats.." seats",10,e+40,11
?"act slots: "..n.slots,10,e+48,11
?"cost: $"..n.cost,10,e+56,11
local l,e=e+72,c.money>=n.cost local t,o=e and 10or 5,e and 5or 6?"> purchase upgrade",10,l,t
if not e then?"not enough money (need $"..n.cost..")",10,l+12,8
end else?"maximum tent level reached",10,e+20,7
?"❎: back",10,110,5
end end function e9()local e=c.tent_level+1if e>#u then return end local e=u[e]s()j("upgrade to "..e.name.."?","cost: $"..e.cost,I,70)end function U()return el()end function el()local e=0for n=1,#c.owned_acts do local n=c.owned_acts[n].id local n=h(n)e+=n.upkeep end return e end function ez()k=p(2,k)if k==1then if btnp(0)then c.ticket_price=max(1,c.ticket_price-1)elseif btnp(1)then c.ticket_price=min(30,c.ticket_price+1)end end if btnp(4)and k==2then o="confirm_show"L=1end if btnp(5)then o="main_menu"return end end function ej()local e,n=function()eV()o="show_results"end,function()o="run_show"end L=x(e,n,L)end function eV()local e=l(c.current_city)local n,l=e.base_cost,U()a.total_cost=n+l a.pre_show_demand=e.demand local n=eW()local l=n.attendance a.attendance=l a.revenue=l*c.ticket_price a.profit=a.revenue-a.total_cost a.price_factor=n.price_factor a.quality_score=n.quality_score a.fav_bonus=n.fav_bonus a.num_fav_matches=n.num_fav_matches a.target_price=n.target_price c.money+=a.profit g={}for e=1,#c.owned_acts do local e=c.owned_acts[e]if e.skill<5then local n=flr(e.skill)e.skill=min(5,e.skill+.15)local l=flr(e.skill)if l>n then add(g,e)end end end local n,l=30,a.attendance/max(1,e.population/10)if l>.5then n=n+10end if e.demand<50then n=n+(50-e.demand)/2end e.demand=max(0,e.demand-n)for e=1,#d do if d[e].id~=c.current_city then local n=3+flr(rnd(10))d[e].demand=min(100,d[e].demand+n)end end c.week+=1if c.week>=30and o~="season_end"then o="season_end"return end a.audience_feedback=eX()b=1z=1end function eW()local n,i,e=l(c.current_city),q(),{}if#c.owned_acts==0then e.attendance=0e.price_factor=1e.quality_score=0e.fav_bonus=1e.num_fav_matches=0e.target_price=1return e end local l if n.population<2000then l=n.population else l=2000+(n.population-2000)^.8end local t=1if c.week<=3then t=1.15elseif c.week<=6then t=1.05end local o if n.demand<20then o=(n.demand/100)^3else o=(n.demand/100)^1.2end local d,l,t=l*.15*o*t,0,0for e=1,#c.owned_acts do local e=c.owned_acts[e]local o=h(e.id)l+=e.skill if eo(n.favorites,o.type)then t+=1end end local o,l=l/#c.owned_acts,min(1.3,.8+#c.owned_acts*.1)local l,a=(.45+o/6)*l,1+n.population/15000local a=.5*a if l<a and n.population>2000then l=l*.9end e.quality_score=l e.num_fav_matches=t local a=min(1.4,1+t*.15)e.fav_bonus=a local t,o=4+o*1.2,1+n.base_cost/1200local t=max(1,t*o)e.target_price=t local o,n,t=c.ticket_price/t,n.price_sensitivity or 1if c.week<=4then n=n*.8end if o<=1then t=1+(1-o)*.2else t=1/o^(1.6*n)end e.price_factor=t local n,l=d*l*a*t,.9+rnd(.2)n=n*l n=max(0,flr(n))if c.week<=2then n=max(n,30)end n=min(n,i.seats)e.attendance=n return e end function eX()local e,n,l={},l(c.current_city),q()local l=a.attendance/max(1,l.seats)*100if a.price_factor<.75then add(e,"tickets felt too expensive.")elseif a.price_factor>1.15then add(e,"such a bargain for the show!")elseif c.ticket_price>a.target_price*1.5then add(e,"that ticket price was way too high!")elseif c.ticket_price<a.target_price*.5then add(e,"could have charged more!")end if a.pre_show_demand<10then add(e,"nobody cares about this show anymore.")elseif a.pre_show_demand<20then add(e,"everyone's seen this already.")elseif a.pre_show_demand<65then add(e,"felt like i just saw this...")elseif a.pre_show_demand>95then add(e,"the town was buzzing!")end if a.num_fav_matches==0and#n.favorites>0and#e<3then local n=n.favorites[flr(rnd(#n.favorites))+1]add(e,"wish there were "..n.." acts.")end if a.quality_score<.6and#e<3then add(e,"the performance felt flat.")elseif a.quality_score>1.1and#e<3then add(e,"what an incredible show!")end if l>=98and#e<3then add(e,"it was totally packed!")elseif l<30and#e<3then add(e,"seemed pretty empty.")end if#e==0then add(e,"a decent show overall.")end local l,t,n={},min(#e,3),{}for e=1,#e do add(n,e)end for e=#n,2,-1do local l=flr(rnd(e))+1n[e],n[l]=n[l],n[e]end for t=1,t do add(l,e[n[t]])end return l end function eA()if b==1then if btnp(4)then b=2elseif btnp(5)then if#g>0then o="act_level_up"elseif e()then o="random_event"else o="main_menu"end end elseif b==2then if btnp(4)or btnp(5)then if#g>0then o="act_level_up"elseif e()then o="random_event"else o="main_menu"end end end end function e()if c.week<=3then return false end local e=15+flr(rnd(11))if flr(rnd(100))<e then local e=flr(rnd(#V))+1f=V[e]eY(f)return true end return false end function eY(e)if e.effect_type=="money"then c.money+=e.effect_value elseif e.effect_type=="demand"then local n=l(c.current_city)n.demand=mid(0,n.demand+e.effect_value,100)elseif e.effect_type=="both"then c.money+=e.effect_value_money local n=l(c.current_city)n.demand=mid(0,n.demand+e.effect_value_demand,100)end end function eI()if btnp(5)or btnp(4)then f=nil o="main_menu"end end function eJ()if f==nil then return end s()rectfill(5,15,123,113,0)rect(5,15,123,113,f.is_positive and 11or 8)local e=20?"event: "..f.name,10,e,7
e+=14local l,n=f.description,1while n<=#l do local t=n+28-1if t>=#l then?sub(l,n),10,e,7
n=#l+1else local o=nil for e=t+1,n,-1do if sub(l,e,e)==" "then o=e break end end if o then?sub(l,n,o-1),10,e,7
n=o+1else?sub(l,n,t),10,e,7
n=t+1end end e+=7if e>83then break end end e+=7local n,l,e="",f.is_positive and 11or 8,e if f.effect_type=="money"then if f.effect_value>0then n="money: +$"..f.effect_value else n="money: $"..f.effect_value end?n,10,e,l
e+=7elseif f.effect_type=="demand"then if f.effect_value>0then n="demand: +"..f.effect_value.."%"else n="demand: "..f.effect_value.."%"end?n,10,e,l
e+=7elseif f.effect_type=="both"then local n=""if f.effect_value_money>0then n="money: +$"..f.effect_value_money else n="money: $"..f.effect_value_money end?n,10,e,l
e+=7local n=""if f.effect_value_demand>0then n="demand: +"..f.effect_value_demand.."%"else n="demand: "..f.effect_value_demand.."%"end?n,10,e,l
e+=7end end function eC()D=p(#d,D)if btnp(4)then c.selected_city_id=d[D].id o="city_details"ei=1end if btnp(5)then o="main_menu"end end function eE()if btnp(4)then local e=c.selected_city_id if e~=c.current_city then local e=Q(c.current_city,c.selected_city_id)if c.money>=e then o="confirm_travel"J=1end end end if btnp(5)then c.selected_city_id=nil o="cities_list"end end function eG()local e,n=function()local e,n=Q(c.current_city,c.selected_city_id)if c.money>=e then c.money-=e c.week+=n if c.week>=30and o~="season_end"and o~="game_over"then o="season_end"return end c.current_city=c.selected_city_id c.selected_city_id=nil o="main_menu"else o="city_details"end end,function()o="city_details"end J=x(e,n,J)end function eD()s()local e=m("travel",nil,12)local n=e+10for o=1,#d do local e,t=d[o],n+(o-1)*10local a=e.id==c.current_city local l=a and 5or 7local n,i=l,a and 6or 10if e.demand<10then n=8elseif e.demand<30then n=9elseif e.demand>80then n=11else n=l end if o==D then l=i n=i?">",5,t,i
end local o,e,a=e.name.." ","("..e.demand.."%)",a and" (current)"or""?o,15,t,l
local o=#o*4?e,15+o,t,n
local e=#e*4?a,15+o+e,t,l
end?"⬆️⬇️: navigate",15,108,5
?"🅾️: select city",15,118,5
?"❎: back",80,118,5
end function eF()if c.selected_city_id==nil then return end s()local e=l(c.selected_city_id)if e==nil then return end local t=e.id==c.current_city local n=t and"(current location)"or nil local n=m("city: "..e.name,n,n and 22or 12)local n=n+5?"population: "..e.population,10,n+8,7
?"weekly rent: $"..e.base_cost,10,n+16,7
?"demand: "..e.demand.."%",10,n+24,7
?"region: "..e.region,10,n+32,7
local l="favorites: "for n=1,#e.favorites do l=l..e.favorites[n]if n<#e.favorites then l=l..", "end end?l,10,n+40,7
if not t then local l,t=Q(c.current_city,e.id)local e=c.money>=l?"travel time: "..t.." week"..(t>1and"s"or""),10,n+48,7
local t=e and 7or 8?"travel cost: $"..l,10,n+56,t
if not e then?"not enough money to travel!",10,n+64,8
end local n,l=n+8*(e and 9or 10),e and 10or 5?"> travel here",10,n,l
?"🅾️: travel to city",10,108,e and 5or 6
?"❎: back",10,118,5
else?"❎: back",10,118,5
end end function eH()if c.selected_city_id==nil then return end local n=l(c.selected_city_id)if n==nil then return end s()local e,l=Q(c.current_city,c.selected_city_id)local e="travel cost: $"..e e=e.."\ntravel time: "..l.." week"..(l>1and"s"or"")j("travel to "..n.name.."?",e,J,80)end function eq()local e,n=l(c.current_city),U()local n=e.base_cost+n j("ready to perform in\n"..e.name.."?","total cost: $"..n,L,70)end function eB()local e,n=l(c.current_city),q()s()?"show results",38,15,8
if b==1then?"attendance: "..a.attendance.."/"..n.seats,10,35,7
local e=0if n.seats>0then e=flr(a.attendance/n.seats*100)end local n=7if e>=90then n=11elseif e<=30then n=8end?"capacity: "..e.."%",10,45,n
?"ticket revenue: $"..a.revenue,10,65,7
?"total costs: $"..a.total_cost,10,75,8
local n,e="profit: $"..a.profit,11if a.profit<0then n="loss: $"..abs(a.profit)e=8elseif a.profit<50then e=10end?n,10,95,e
?"press 🅾️ for feedback",15,115,5
?"press ❎ to continue",15,122,5
elseif b==2then?"audience reactions:",10,30,7
local e=a.audience_feedback for n=1,#e do?"- "..e[n],4,40+n*10,6
end?"press 🅾️ or ❎ to continue",15,115,5
end end function ex()local e,t=l(c.current_city),U()local o=e.base_cost+t s()local n=m("run show",nil,12)local n=n+10?"location: "..e.name,10,n,7
?"population: "..e.population,10,n+8,7
local l=7if e.demand<10then l=8elseif e.demand<30then l=9elseif e.demand>80then l=11end?"demand: "..e.demand.."%",10,n+16,l
if e.demand<15then?"demand too low! travel soon!",10,n+24,8
end local l="favorites: "for n=1,#e.favorites do l=l..e.favorites[n]if n<#e.favorites then l=l..", "end end?l,10,n+32,7
?"city rental: $"..e.base_cost,10,n+40,7
?"act costs: $"..t,10,n+48,7
?"total cost: $"..o,10,n+56,11
local l,e=n+72,7if k==1then e=10?">",5,l,e
?"◀",13,l,e
?"▶",110,l,e
end?"  ticket price: $"..c.ticket_price,10,l,e
local n,e=n+80,7if k==2then e=10?">",5,n,e
end?"start the show",10,n,e
end function eK()if btnp(5)or btnp(4)then z+=1if z<=#g then else if e()then o="random_event"else o="main_menu"end end end end function eL()if z>#g then return end local n=g[z]local e=h(n.id)if e==nil then return end local n,l=flr(n.skill),{"practice makes perfect!","what talent!","standing ovation!","spectacular skills!","true professionals!"}local t=(n*3+#e.id)%#l+1M("★ skill increase! ★",e.name,n,l[t])end function Y()dset(0,c.week)dset(1,c.money)dset(2,c.tent_level)dset(3,c.ticket_price)dset(4,c.reputation)local e=1for n=1,#d do if d[n].id==c.current_city then e=n break end end dset(5,e)for e=1,10do if e<=#c.owned_acts then local n,l=c.owned_acts[e],0for e=1,#r do if r[e].id==n.id then l=e break end end dset(10+e,l*10+flr(n.skill))else dset(10+e,0)end end for e=1,10do if e<=#c.previously_owned_acts then local l,n=c.previously_owned_acts[e],0for e=1,#r do if r[e].id==l then n=e break end end dset(20+e,n)else dset(20+e,0)end end for e=1,10do if e<=#d then dset(30+e,d[e].demand)end end for e=1,5do dset(40+e,e<=#i and i[e]or 0)end end function eU()if dget(0)==0then return end local e=dget(0)if e>=30then return end c.week=e c.money=dget(1)c.tent_level=dget(2)c.ticket_price=dget(3)c.reputation=dget(4)local e=dget(5)if e>0and e<=#d then c.current_city=d[e].id end c.owned_acts={}for e=1,10do local e=dget(10+e)if e>0then local n,e=flr(e/10),e%10if n>0and n<=#r then local n=r[n].id add(c.owned_acts,{id=n,skill=e})end end end c.previously_owned_acts={}for e=1,10do local e=dget(20+e)if e>0and e<=#r then add(c.previously_owned_acts,r[e].id)end end for e=1,10do if e<=#d then d[e].demand=dget(30+e)end end i={}for e=1,5do local e=dget(40+e)if e>0then add(i,e)end end end function eM()if btnp(5)or btnp(4)then o="main_menu"end end function eN()eZ"game saved!"end function eZ(a,e,n,l,t,o)e=e or 24n=n or 45l=l or 80t=t or 30o=o or 11rectfill(e,n,e+l,n+t,0)rect(e,n,e+l,n+t,7)?a,e+(l-#a*4)/2,n+12,o
?"press 🅾️ or ❎",e+15,n+22,5
end function j(e,l,t,o)o=o or 80rectfill(8,25,120,110,4)rect(8,25,120,110,8)local n=33if e and e~=""then local t=1while t<=#e do local l=nil for n=t,#e do if sub(e,n,n)=="\n"then l=n break end end local o=l and l-1or#e local o=sub(e,t,o)?o,8+(112-#o*4)/2,n,7
n=n+10t=l and l+1or#e+1end end n=n+4if l then local t=1while t<=#l do local e=nil for n=t,#l do if sub(l,n,n)=="\n"then e=n break end end local o=e and e-1or#l local o=sub(l,t,o)?o,8+(112-#o*4)/2,n,10
n=n+8t=e and e+1or#l+1end end local n,l,e=t==1and 10or 7,t==2and 10or 7,25+o-25?"yes",38,e,n
?"no",78,e,l
local n=t==1and 28or 68?">",n,e,10
?"⬅️➡️: change",18,93,5
?"🅾️: select",78,93,5
?"❎: cancel",48,103,5
end function M(e,n,l,t)rectfill(10,25,118,105,8)rect(10,25,118,105,7)?"★",15,30,10
?"★",108,30,10
?"★",15,95,10
?"★",108,95,10
?e,10+(108-#e*4)/2,40,7
?n,10+(108-#n*4)/2,55,11
if l~=nil then local e,n="skill level: ",S(l)local l=(#e+#n)*4local l=10+(108-l)/2?e,l,70,7
?n,l+#e*4,70,10
end?t,10+(108-#t*4)/2,85,15
?"press 🅾️ or ❎ to continue",13,115,5
return 10,25,108,80end function x(l,n,e)if btnp(0)or btnp(1)then e=3-e end if btnp(4)then if e==1then l()else n()end end if btnp(5)then n()end return e end function Q(e,n)local e,n=l(e),l(n)if e==nil or n==nil then return 0end local e,n,l=e.region,n.region,1if e~=n then if e=="central"and(n=="east"or n=="west")or(e=="east"or e=="west")and n=="central"then l=2elseif e=="east"and n=="west"or e=="west"and n=="east"then l=3end end local e=el()local e=e*l return e,l end function eO()if btnp(4)or btnp(5)then et(c.money)dset(0,0)o="high_scores"n=1end end function eP()M("game over","bankruptcy!",nil,"you ran out of money!")end function eQ()if btnp(4)or btnp(5)then et(c.money)dset(0,0)o="high_scores"n=1end end function eR()local e,n,l="season end!","congratulations!","your score: $"..c.money M(e,n,nil,l)end function et(e)K=false if#i<5or e>i[#i]then add(i,e)for e=1,#i do for n=e+1,#i do if i[e]<i[n]then i[e],i[n]=i[n],i[e]end end end while#i>5do deli(i,#i)end K=true for e=1,5do dset(40+e,e<=#i and i[e]or 0)end return true end return false end function eS()if btnp(4)or btnp(5)then o="splash_screen"_=1end end function eT()map(0,0,0,0,16,16)rect(10,10,118,118,7)rectfill(15,15,113,105,0)rect(15,15,113,105,5)?"★ top 5 scores ★",28,20,10
?"rank",26,35,7
?"score",56,35,7
line(25,42,105,42,5)for e=1,5do local n,l,t=48+(e-1)*10,7,7if e<=#i and K and e==ne()then l=10t=10?"new!",90,n,10
end?e..".",26,n,l
if e<=#i then?"$"..i[e],56,n,t
else?"---",56,n,6
end end?"press 🅾️ to continue",25,110,5
end function ne()for e=1,#i do if K and i[e]==c.money then return e end end return 0end
__meta:title__
circus tycoon
by onoz
__label__
11111111111111111111112811111111111111111111111111111111111111111111111111111111111111111111111111111111821111111111111111111111
11111111111111111111112811111111111111111111111111111111111111111111111111111111111111111111111111111112821111111111111111111111
11111111111111111111281188111111111111111111111111111111111111111111111111114911111111111111111111111188128211111111111111111111
11111111111111111112241122211111111111111941111111111111119411111111111111114911111111149111111111111222124221111111111115911111
11111111111111111118211111821111111111111991111111111111119411111111111111111111111111199111111111112811111281111111111114911111
11111451111111154442211111222221111111111111111111111111111111111111111111111111111111111111111112222211111222222111111111111111
11111a41111111149991111111128881111111111111111111111111111111111111111111111111111111111111111114882111111118882111111111111111
11111551111115499991111111111128481111111111111111111111111111111111111111111111111111111111118882111111111118884411111111111111
11111111111115999991115555555112222555555115555555555555111111111115555555111111155555111155554421115555555112288811111111111111
11111111111199999991119999999111114999999119999999999999111111111114999999111111199999511599999511114999994111148888111111111111
11111111133344499441599999999999114999999119999999999999941111111599999999999514999999511599999411199999999994194222333111111111
11111111333311149111499949999999115999994114999999444999995111115499999499999515999999511149994511599944449994144111333311111111
11111333333311111119999911149999111199951111499995111999999511119999994199999511199941111114991114999911115994111111333333311111
11111333333311111549994511115999111599941111499994111549999511549999955155999511199941111114991114999911111594111111333333311111
88888113333311111499995111111999111599941111499994111159999511499999911111999511199941111114991114999951111144111111333331188888
28888113333311115499995111111111111599941111499994111149999511499995111111111111199941111114991114999999111111111111333331188882
12888111333311119999411111111111111599941111499995111999999511499995111111111111199941111114991114999999994111111111333311188821
12888111133311119999411111111111111599941111499999444999995111499995111111111111199941111114991111599999999451111111331111188821
12888111113311119999411111111111111599941111499999999999941111499995111111111111199941111114991111199499999945111111331111188821
11188111111111119999411111111111111599941111499999999999111111499995111111111111199941111114991111111149999999111111111111182111
11122111111111119999941111111111111599951111499999449999441111499995111111111111199941111114991111111154599999941111111111122111
11111111111111119999995111111111111599951111499995114999991111599995111111111111199941111114991111111111149999941111111111111111
11111111111111111499995111111999111599951111499994111499999511499999911111159511199941111114991114994111115999941111111111111111
11111111111111111499994511155999111599951111499995111499999511549999955111549511149995111159941114994511115999941111111111111111
11111111111111111499999911149999111599951111499995111499999511114999994111999511119999111599911114999951115999941111111111111111
11111111111111111159999999999941114999999114999999411159999941111599999444994111159999999999911114999999999999511111111111111111
11111111119911111114999999999451114999999119999999911119999995111549999999951111114999999999411114949999999999111111111111111111
11111111114411111111599999999111114999999119999999911111999999511114999999111111111499999995111119915999999941111111111991111111
11111111111111111111555555555111115555555115555555511111555555111115555555111111111555555551111115415555555551111111111441111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111112111111121111111111111111111111121111111111111112111111111112111111112222222111111111111111111
11111111111111111288888888888888128888821288888211128888818821111288888811111111128888881111128888411118888888111111111111111111
11111111111111111288888888888888128888821288888211488888888821114888888881111111888888888211128888881118888888111111111111111111
11111111111111111288822488821888212888211128821112888811288821128888228888211112888212888821112888884112148811111111111111111111
11111111111111111288211288811248211288821128821128888211288821288884118888411128888111288882111888888211128811111111111111111111
11115951111111111282111288811118211188881288211288882111118812888881111888881288881111128888112888888211128811111111111111111111
11115911111111111121111288811112111188884881111288882111112212888211111288881288821111112888112888888821128811111111111111111111
11111111111111111111111288811111111128888821111288821111111112888211111188881288811111112888112882288882128811111111111111111111
11111111111111111111111288811111111112888811111288821111111112888211111188881288811111112888112882128888148811111111111111111111
11111111111111111111111288811111111111288811111288821111111112888211111188881288811111112888112882118888888811111155111111111111
111111111111111111111112888111111111112888111112888211111111128882111111888812888111111128881128821118888888111111a4111111111111
11111111111111111111111288811111111111288811111288882111112221888821111288881288821111118888112882111288888811111155111111111111
11111111111111111111111288811111111111288811111248884111128821288882112888841288882111128882112882111128888811111111111111111111
11111111111194111111111288811111111111288811111118888811288821188888128888211128888211288821112882111112888811111111111111111111
11111111111194111111118888881111111118888881111111888888888111118888888882111111888888888211128888211111188811111111111111111111
11111111111111111111118888881111111118888881111111128888881111111488888821111111128888882111128888411111188811111111111111111111
11111111111111111111112222221111111112222221111111122222221111111222222211111111122222221111122222211111122211111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111114511111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111119911111
11111111111111111111111111111111111111111111111111111111111111188211111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111188888888411111111111111111111111111111111111111111111111111111111
11115111111115555551111111111159511111111111111111111111111111188888888821111111111111111111111111111111111111111111111111111111
1115a511111149999941111111111159511111111111111111111111111111188888888882111188111111111111111111111551111113333333311111111111
111145111114999999941111111111111111111111111111951111111111111888888888822222221111111115451111111114a1111133333333331111111111
111111111159999999995111111111111111111111111115941111111111111888888888888888111111111115a5111111111151111333333333333111111111
11111111199999999fa99411111111111111111111111111111111111111111888811111888881111111111111111111111111111133333333dfd33311111111
11111111199999999aaf94111111111111111111111111111111111111111118822111112288811111111111111111111111111111333333333ddd3311111111
111111111999999999af941111111111111111111111111111111111111111188111111111211111111111111111111111111111113333333333df3311111111
111111111999999999af941111111111111111111111111111111111511111188211111111111111111111111111111111111111113333333333dd3311111111
11111111199999999999941111111111111111111111111111111115a51111188211111111111111111111111111111111111111113333333333333311111111
11111111199999999999941111111111111111111111111111111111511111188111111111111111111111111111111111111111113333333333333311111111
11111111199999999999941111111111155111111111111111111111111111188211111111111111111111111111111111111111113333333333333311111111
11111111154999999999551111111111199111111111111111111111111112888821111111111111991111111111111288888211111133333333331111111111
11111111114999999999111111111111155111111111111111111111111128888882111111111111991111111111112888888821111133333333331111111111
11111111114999999999111111111111111111111111111111111111111188888888111111111111111111111111128888888881111133333333331111111111
1111111111159999994111288888211111111111111111111111111111188888888881111111111111111111111128888888f488211113333333311111111111
111111111111499999511128888821111111111111111111111111111228e48e888e82211111111111111111111148888888eee8211113333333311111111111
111111111111149991111888888888111111111111111111111111111488fe8fe8ef882111111111111111111111488888888ef8211111133331111111111111
111111111111114951122888888f8822111111111149111111111111884ffe8f48eff48811111111111111111111488888888848211111113311111111111111
11111111111111491112888888efe8821111111111491111111111188eff888f8884ffe882111111111111111111488888888888211111113311111111111111
1111111111111499951288888888ef821111111111111111111111284ffe888fe888fff482211111111111111111488888888888211111133331111119911111
1111111111111549411288888888ef82111111111111111111111488ffe8888ffe88ffff88811111111111111111288888888888211111135531111115411111
11111111111111491112888888888882111111111111111111118888fff8888ffe888efffe881111111111441111128888888881111111118811111111111111
1111149111111149111288888888888211111111111111111122888efe4888effe888effff482211111111991111118888888881111111118811111111111111
111114911111115911128888888888821111111111111111112888eff8888efffe888efffff88211111111111111118888888881111111118811111111111111
11111111111111591111288888888821111111111111111118888ffff4888efffe88884ffff88881111111111111111888888211111111118811111111111111
1111111111111159111118888888881111111111111111122888efffe8888effff48884ffffe8882211111111111111248882211111111118811111111111111
1111111111111441111118888888881111151111111111128884ffff88888effffe8888fffffe888211111111111111118881111111111112221111111111111
11111111111114411111122888882211115a41111111118888efffff888884ffffe88888fffffe88888211111111111111811111111111111181111111111111
1111111111111441111111188888211111145111111248888effffe88888efffffe888888effffe8888821111111111112821111111111111281111111111111
1111111111119511111111118881111111111111111888884fffff488888ffffffe888888efffff4888882111111111128881111111111111182111111111111
11111111111545111111111112811111111111111288888efffff8888888efffffe8888884ffffffe88888211111111111311111111111111118411111111111
1111111111491111111111112882111111111118888888effffff8888888effffffe8888888ffffffe8888888111111111311111111111111114411111111111
111111111144111111111111888821111111122888888effffffe888888effffffff8888888effffffe888888222111111311111111491111118811111111111
111111111941111111111111128111111111188888884ffffffe8888888fffffffff88888888fffffff488888888211111311111111991111111241111111111
1111111119411111151111111281111111288888888effffffe88888888fffffffff888888888effffffe8888888888111133111111111111111181111111111
11111111545111119a111111128111112288888888effffffe888888888fffffffffe888888888effffffe888888888222133311111111111111281111111111
111111159111111154111111128111128888888884fffffff8888888884ffffffffff8888888888fffffff888888888888111311111111111111281111111111
1111111591111111111111118211288888888888effffffe888888888efffffffffff88888888888effffffff888888888882111111111111111122211111111
1111111591111111111111112222888888888eeeffffffe8888888888efffffffffffe88888888888efffffffee8888888888482111111111111118811111111
1111111591111111111111121288888888888ffffffffe88888888888effffffffffffe88888888888fffffffff8888888888888221111111111118811111111
11111111595111111112888888888888888fffffffffe88888888888ffffffffffffffe888888888888efffffffffe8888888888888811111111118811111111
111111111941111111228888888888884849999999944888888888884999999999999944888888888884eeeeee99948488888888888811111111118811111111
11111111111111111128222222222224999999999942222222222222499999999999949922222222222224949999999942222222222211111111122211111111
11111111111111111122222222222224949999999942222222222222499999999999999422222222222224999999994942222222222811111111281111111111
11119411111111111128222222222224999999999942222222222222499999999999999422222222222224999999999942222222222811111111281111111111
111145111111111111222222222222449999999999e8822222222288e99999999999999988222222222889999999999944222222222211111112221111111111
111111111111111111118222222222ef4999999999f8822222222288f94999999999999f8822222222288f9499999994ff222222222111111118211111111111
111111111111111111128822222888eff9999994eff8882222222888ffff99999999ffff8882222222888ffe4999999ffe882222288111111111111111111111
111111111111111111128888888888effeeeeeeefff8888888888888fffffeeeeeeeffff8888888888888fffeeeeeeeffe888888888111111111111111111111
111111111111111111128888888888effffffffffff8888888888888ffffffffffffffff8888888888888ffffffffffffe888888888111111111111111111111
111111111111111111128888888888effffffffffff8888888888888ffffffffffffffff8888888888888ffffffffffffe888888888111111111111114511111
11111111111149111112888888888effffffffffff8888888888888efffffd55555fffffe8888888888884ffffffffffffe88888888211111111111119911111
11111111111149111112888888888ffffffffffffe8888888888884ffffdd111111ddffff4888888888888effffffffffff88888888821111111111111111111
11111111111111111188888888888ffffffffffffe8888888888888ffff11111111116fff8888888888888effffffffffff88888888821111111111111111111
11111111111111111188888888888ffffffffffffe8888888888888ffd111111111111dff8888888888888effffffffffff88888888811111111111111111111
1111111111111111118888888888effffffffffffe8888888888888f6511111111111156f8888888888888effffffffffff88888888821111111111111111111
111111111111111111888888888efffffffffffffe8888888888888f1111111111111111f8888888888888effffffffffff88888888884111119411111111111
111111111111111128888888888effffffffffff8888888888888eff1111111111111111ffe8888888888884ffffffffffffe888888882111119911111111111
111111111111111128888888888effffffffffff8888888888888eff1111111111111111ffe8888888888888ffffffffffffe888888888211111111111111111
111111111111111128888888888effffffffffff8888888888888ef611111111111111116fe8888888888888ffffffffffffe888888888811111111111111111
11111151111111112888888888ffffffffffffff8888888888888fd111111111111111111df8888888888888ffffffffffffff88888888811111111111111111
111114a1111111128888888888fffffffffffff88888888888888fd111111111111111111df88888888888888fffffffffffff88888888882111111111111111
11111541111111188888888888ffffffffffffe88888888888884fd111111111111111111df48888888888888fffffffffffffe8888888882111111111441111
1111111111111118888888888ffffffffffffff8888888888888ffd111111111111111111dff8888888888888ffffffffffffffe888888882111111111991111
1111111111111288888888888ffffffffffffe88888888888888ffd111111111111111111dff88888888888888effffffffffff4888888888811111111111111
111111111111128888888888effffffffffff48888888888888effd111111111111111111dffe8888888888888effffffffffffe888888888811111111111111
11111111111112888888888efffffffffffffe888888888888efffd111111111111111111dfffe888888888888effffffffffffff88888888811111111111111
1111111111112888888888ffffffffffffff88888888888888efffd111111111111111111dfffe88888888888888ffffffffffffff8888888882111111111111
2222222222228888888888eeeeeeeeeeeeee88888888888888eeee42222222222222222224eeee88888888888888eeeeeeeeeeeeee8888888882222222222222
88888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888
22222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222222
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
11111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
__gfx__
00000000444444444444444444444444111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
00000000444444444444444444444444111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
00000000448888888888888888888844111111111111000000000001111111110000000000000000000000000000000000000000000000000000000000000000
00000000448aa888888aa888888aa844111111111110044444444400001111110000000000000000000000000000000000000000000000000000000000000000
00000000448aa888888aa888888aa844111111111100494444444499001111110000000000000000000000000000000000000000000000000000000000000000
00000000448888888888888888888844111111111004494444444499011111110000000000000000000000000000000000000000000000000000000000000000
00000000448888111111111111888844111111110044499999999999011111110000000000000000000000000000000000000000000000000000000000000000
00000000448888111111111111888844111111110444449999999999011111110000000000000000000000000000000000000000000000000000000000000000
00000000448888110000000011888844111111110444449999999999001111110000000000000000000000000000000000000000000000000000000000000000
00000000448888110000000011888844111111110444449911994549201111110000000000000000000000000000000000000000000000000000000000000000
00000000448888110000000011888844111111110444449911995149401111110000000000000000000000000000000000000000000000000000000000000000
00000000448aa81100000000118aa844111111110444449944155499401111110000000000000000000000000000000000000000000000000000000000000000
00000000448aa81100000000118aa844111111110444449999554999201111110000000000000000000000000000000000000000000000000000000000000000
00000000448888110000000011888844111111110004444499999944001111110000000000000000000000000000000000000000000000000000000000000000
00000000448888110000000011888844111111111100444499999942011111110000000000000000000000000000000000000000000000000000000000000000
00000000448888110000000011888844111111111100044444444400011111110000000000000000000000000000000000000000000000000000000000000000
00000000448888111111111111888844111001111100444444444401111111110000000000000000000000000000000000000000000000000000000000000000
00000000448888111111111111888844111041111109994444444401111111110000000000000000000000000000000000000000000000000000000000000000
00000000448888888888888888888844111041111109999499440001111111110000000000000000000000000000000000000000000000000000000000000000
00000000448aa888888aa888888aa844111041110009999999440001111111110000000000000000000000000000000000000000000000000000000000000000
00000000448aa888888aa888888aa844111099900499995599544401111111110000000000000000000000000000000000000000000000000000000000000000
00000000448888888888888888888844111099990999995499459901111111110000000000000000000000000000000000000000000000000000000000000000
00000000444444444444444444444444111099990999995499459901011111110000000000000000000000000000000000000000000000000000000000000000
00000000444444444444444444444444111004400999995149549900011111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111100449999999944454999011111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111110004444444444454444011111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111111000000000000000000001111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111111022442224422244422401111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111100048998889988899988400111110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111002444948889988849944440011110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111018899988889988888999880011110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000111010000000000000000000000011110000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
11111111111221111111111111111111111111111111111111122111111111110000000000000000000000000000000000000000000000000000000000000000
11111111112222111111551111111511111111411115511111222211111155110000000000000000000000000000000000000000000000000000000000000000
11511111522112211111551111111511111111111115511112211222111155110000000000000000000000000000000000000000000000000000000000000000
11551114951111222111111111111111111111111111111222111128211111110000000000000000000000000000000000000000000000000000000000000000
11111149951444522444554444441111154441115441144421544512821111110000000000000000000000000000000000000000000000000000000000000000
11113355414999941499559999994111599999519995199414999945223311110000000000000000000000000000000000000000000000000000000000000000
11133311149415991194114941599415999149415951159159911541113331110000000000000000000000000000000000000000000000000000000000000000
88233311599111551194114941149414945115515951159159941151113332820000000000000000000000000000000000000000000000000000000000000000
28213311995111111194114945499514941111115951159159999411113312820000000000000000000000000000000000000000000000000000000000000000
12211311995111111194114999995114941111114951159115599941113112210000000000000000000000000000000000000000000000000000000000000000
11111111999111111194114945994114941111114951159111114994111111110000000000000000000000000000000000000000000000000000000000000000
11111111599511491194114941599414994115415951159159511499111111110000000000000000000000000000000000000000000000000000000000000000
11111111149954941599519991199411499459411995595159945495111111110000000000000000000000000000000000000000000000000000000000000000
11111411119999411999559995159941149995111499945154499941111551110000000000000000000000000000000000000000000000000000000000000000
11111111111555111155115551115551115551111155511111155511111551110000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111121111111110000000000000000000000000000000000000000000000000000000000000000
11111111188888882882288212882821288821112888212882128881111111110000000000000000000000000000000000000000000000000000000000000000
11111111282282281282182128812812882882128218821288212821111111110000000000000000000000000000000000000000000000000000000000000000
11451111121282121188281288211228821288288111881288812811111111110000000000000000000000000000000000000000000000000000000000000000
11111111111282111128811282111118211188282111281222822811111111110000000000000000000000000000000000000000000000000000000000000000
11111111111282111118811282111118211188282111281221288811141111110000000000000000000000000000000000000000000000000000000000000000
11111111111282111118811288212828821288288212881221188811151111110000000000000000000000000000000000000000000000000000000000000000
11111141111282111128821128828812882882128828811882112811111111110000000000000000000000000000000000000000000000000000000000000000
11111111111222111128821112282111288211112282112282112211111111110000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111111111155110000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111112822211111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
15511154451111145111111111111112888821121111111111151113331111110000000000000000000000000000000000000000000000000000000000000000
11511499995111111111111141111112888888221111541111551133333111110000000000000000000000000000000000000000000000000000000000000000
11114999494111111111111111111112821128211111111111111333333311110000000000000000000000000000000000000000000000000000000000000000
111149999f411111111111111111511221111111111111111111133333f311110000000000000000000000000000000000000000000000000000000000000000
11114999994111111111111111155112211111111111111111111333333311110000000000000000000000000000000000000000000000000000000000000000
11115999994111115511111111111118811111115111111222211333333311110000000000000000000000000000000000000000000000000000000000000000
11111499991111111111111111111188881111115111111888821133333111110000000000000000000000000000000000000000000000000000000000000000
11111599951288211111111111111288882111111111118888f82113331111110000000000000000000000000000000000000000000000000000000000000000
11111159512888821111151111112ff48f4211111111118888842111311111110000000000000000000000000000000000000000000000000000000000000000
11111114528884f21111151111124f8488f421111111118888882111311155110000000000000000000000000000000000000000000000000000000000000000
1111111452888842111111111128f48ff8ff42111115112888821111511155110000000000000000000000000000000000000000000000000000000000000000
115511141288888811111111128ff88ff88ff8211115111888821111811111110000000000000000000000000000000000000000000000000000000000000000
11111114112888821111111128ff488ff88fff821111111288211111811111110000000000000000000000000000000000000000000000000000000000000000
11111155112888211551111284ff888ff484fff82211111128111111221111110000000000000000000000000000000000000000000000000000000000000000
1111114511128211151112884ff888fff8884ff48821111128111111121111110000000000000000000000000000000000000000000000000000000000000000
111115511111221111122884fff888ffff888fff4882211113111111122111110000000000000000000000000000000000000000000000000000000000000000
11115511111122111128884fff8884ffff8888fff488822113111551122111110000000000000000000000000000000000000000000000000000000000000000
1111451151112211288884fff8888fffff88888fff48888221311111112211110000000000000000000000000000000000000000000000000000000000000000
111551115111222288884fff88888ffffff88888ffff488882511111112211110000000000000000000000000000000000000000000000000000000000000000
1115511111122888884ffff888884ffffff888888ffff48888822111111211110000000000000000000000000000000000000000000000000000000000000000
111155111288888884ffff888888fffffff4888888ffff4888888811111811110000000000000000000000000000000000000000000000000000000000000000
11111111122222224444482222224444444422222284444422222211112211110000000000000000000000000000000000000000000000000000000000000000
11411111122222284444442222284444444482222284444482222211112111110000000000000000000000000000000000000000000000000000000000000000
111111111182228f444444822228f444444f882228ff4444f8228211122111110000000000000000000000000000000000000000000000000000000000000000
111111111288888ffffff4888888ffffffff888888fffffff8888211111111110000000000000000000000000000000000000000000000000000000000000000
111111511288888ffffff8888888ffffffff8888884ffffff8888211111155110000000000000000000000000000000000000000000000000000000000000000
11111151128888fffffff888888fff1111fff888888fffffff888811111111110000000000000000000000000000000000000000000000000000000000000000
11111111188888fffffff888888ff111111ff888888ffffff4888821111111110000000000000000000000000000000000000000000000000000000000000000
11111111288888ffffff4888888f11111111f8888884ffffff888881155111110000000000000000000000000000000000000000000000000000000000000000
11111111288888ffffff8888884f11111111f4888888ffffff488882111111110000000000000000000000000000000000000000000000000000000000000000
1155111188888fffffff888888451111111154888888fffffff88888111111110000000000000000000000000000000000000000000000000000000000000000
1115111288884ffffff4888888f5111111115f8888884ffffff48888211114110000000000000000000000000000000000000000000000000000000000000000
111111188888fffffff8888888f5111111115f8888888fffffff8888811111110000000000000000000000000000000000000000000000000000000000000000
11111128888fffffff4888888ff5111111115ff8888884fffffff888821111110000000000000000000000000000000000000000000000000000000000000000
22222288888444444888888888422222222224888888888488444888882222220000000000000000000000000000000000000000000000000000000000000000
22222222222222222222222222222222222222222222222222222222222222220000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
11111111111111111111111111111111111111111111111111111111111111110000000000000000000000000000000000000000000000000000000000000000
__map__
0102020202020202020202020202020312120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000190000000000001312120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000190000000000001312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000190000000000001312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000190000000000001312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000190000000000121312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000190000000000121312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
110000001a000000190000000000001312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1112121a1a1a191a190000000000001312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1100000000000000000000000000001312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2122222222222222222222222222222312000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__sfx__
010800001f050000001f050000001f0501f05000000000001f0501f0500000000000000000000000000000001f0501f0500000000000000000000000000000001f0501f050000000000000000000000000000000
000800002405000000240500000024050240500000000000240502405000000000000000000000000000000024050240500000000000000000000000000000002405024050000000000000000000000000000000
000800001f0501f0501f0501f0501f0501f0501f0501f0501f0501f0501f0501f050000000000000000000001f0501f0501f0501f0501f0501f0501f0501f0501f0501f0501f0501f05000000000000000000000
000800002305023050230502305023050230502305023050230502305023050230500000000000000000000023050230502305023050230502305023050230502305023050230502305000000000000000000000
000800001f0501f0501f0501f0501f0501f0501f0501f0501f0501f0501f0501f050000000000000000000001f0501f0501f0501f050000000000000000000001f0501f0501f0501f05000000000000000000000
000800002305023050230502305023050230502305023050230502305023050230500000000000000000000023050230502305023050000000000000000000002305023050230502305000000000000000000000
000800002405024050240502405024050240502405024050240502405024050240500000000000000000000024050240502405024050240502405024050240502405024050240502405000000000000000000000
000800002405024050240502405024050240502405024050240502405024050240500000000000000000000024050240502405024050000000000000000000002405024050240502405000000000000000000000
000800002105021050210502105021050210502105021050210502105021050210500000000000000000000021050210502105021050210502105021050210502105021050210502105000000000000000000000
000800001f050000001f05000000000000000000000000001f050000001f050000000000000000000000000023050000002305000000000000000000000000002305000000230500000024050240500000000000
000800002405000000240500000000000000000000000000240500000024050000000000000000000000000026050000002605000000000000000000000000002605000000260500000028050280500000000000
00080000230500000021050000001f050000001d050000001c050000001a050000001805018050000000000024050240502405024050240502405024050240500000000000000000000000000000000000000000
000800000000000000000000000000000000000000000000000000000000000000000000000000000000000028050280502805028050280502805028050280500000000000000000000000000000000000000000
000800001505015050150501505000000000000000000000150501505000000000000000000000000000000015050150501505015050000000000000000000000000000000000000000000000000000000000000
000800001805018050180501805000000000000000000000180501805000000000000000000000000000000018050180501805018050000000000000000000000000000000000000000000000000000000000000
000800001504015040150401504000000000000000000000150401504000000000000000000000000000000015040150401504015040000000000000000000000000000000000000000015030150301503015030
000800001804018040180401804000000000000000000000180401804000000000000000000000000000000018040180401804018040000000000000000000000000000000000000000000000000000000000000
000800001503015030150301503000000000000000000000000000000000000000001603016030160301603000000000000000000000170301703017030170300000000000000000000018030180301803018030
000800001803018030180301803000000000000000000000000000000000000000001a0401a0401a0401a040000000000000000000001c0501c0501c0501c050000000000000000000001d0601d0601d0601d060
000800001d0601d0601d0601d06000000000000000000000000000000000000000001b0601b0601b0601b06000000000000000000000190501905019050190500000000000000000000018050180501805018050
00080000180501805018050180501805018050180501805018050180501805018050180501805018050180501805018050180500000018050180501805018050180501805018050180501a0501a0501a0501a050
000800001a0501a0501a0501a05000000000000000000000000000000000000000001a0501a0501a0501a05000000000000000000000190501905019050190500000000000000000000018050180501805018050
000800000000000000000000000000000000000000000000000000000000000000002205022050220502205000000000000000000000220502205022050220500000000000000000000021050210502105021050
0008000018050180501805018050180501805018050180501805018050180501805018050180501805018050180501805018050180501f0501f0501f0501f050000000000000000000001d0501d0501d0501d050
000800002105021050210502105021050210502105021050210502105021050210500000000000000000000000000000000000000000180501805018050180501805018050180501805000000000000000000000
0008000000000000000000000000210502105021050210502105021050210502105021050210502105021050210502105021050210501f0501f0501f0501f050000000000000000000001e0501e0501e0501e050
00080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001c0501c0501c0501c050
000800000000000000000000000021050210502105021050210500000000000000001f0501f0501f0501f0501f0500000000000000001c0501c0501c0501c0501c0500000000000000001a0501a0501a05000000
000800001c0501c0501c0501c0501c0501c0501c0501c0501c0501c0501c0501c0500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0008000000000000000000000000000000000000000000000000000000000000000019050000000000000000000000000000000000000000000000000001a0500000000000190500000018040180400000000000
010800000000000000000000000021040210402104021040000000000000000000002204022040220402204000000000000000000000230402304023040230400000000000000000000024040240402404024040
0008000000000000000000000000180401804018040180401804018040180401804018040180401804018040180401804018040180401a0401a0401a0401a040000000000000000000001c0501c0501c0501c050
010800002404024040240402404024040240402404024040240402404024040240402604026040260402604000000000000000000000280502805028050280500000000000000000000029060290602906029060
00080000000000000000000000001d0601d0601d0601d0601d0601d0601d0601d0601d0601d0601d0601d0601d0601d0601d0601d0601f0601f0601f0601f0601f0601f0601f0601f06020060200602006020060
000800002906029060290602906029060290602906029060290602906029060290602b0602b0602b0602b0602b0602b0602b0602b0602c0602c0602c0602c0602c0602c0602c0602c0602d0602d0602d0602d060
0008000020060200602006020060210602106021060210602106021060210602106021060210602106021060210602106021060210601d0601d0601d0601d0601d0601d0601d0601d0601d0601d0601d0601d060
000800002d0602d0602d0602d0602d0602d0602d0602d0602d0602d0602d0602d060290602906029060290602906029060290602906029060290602906029060290602906029060290602c0602c0602c0602c060
000800001d0601d0601d0601d060200602006020060200602006020060200602006020060200602006020060200602006020060200601f0501f0501f0501f0501f0501f0501f0501f0501d0501d0501d0501d050
000800002c0602c0602c0602c0602c0602c0602c0602c0602c0602c0602c0602c0602b0502b0502b0502b0502b0502b0502b0502b050290502905029050290502905029050290502905032050320503205032050
000800001d0501d0501d0501d0502605026050260502605026050000000000000000240502405024050240502405000000000000000021050210502105021050210500000000000000001d0501d0501d0501d050
000800003205000000000000000030050300503005030050300500000000000000002d0502d0502d0502d0502d05000000000000000029050290502905029050290500000000000000002b0502b0502b0502b050
000800001d0500000000000000001f0501f0501f0501f0501f0501f0501f0501f0501a0501a0501a0501a0501a0501a0501a0501a0501c0501c0501c0501c0501c0501c0501c0501c0501f0401f0401f0401f040
000800002b0502b0502b0502b050260502605026050260502605026050260502605028050280502805028050280502805028050280502b0402b0402b0402b0402b0402b0402b0402b04029040290402904029040
000800001f0401f0401f0401f0401d0401d0401d0401d0401d0401d0401d0401d0401d0401d0401d0401d0401d0401d0401d0401d0401d0401d0401d040000002104021040210402104021040210402104021040
00080000290402904029040290402904029040290402904029040290402904029040290402904029040000002d0402d0402d0402d0402d0402d0402d0402d0402d0402d0402d0402d04028040280402804028040
0008000021040210402104021040250402504025040250402d0402d0402d0402d040250402504025040250402d0402d0402d0402d040250402504025040250402d0402d0402d0402d04025040250402504025040
000800000000000000000000000028040280402804028040000000000000000000002804028040280402804000000000000000000000280402804028040280400000000000000000000029040290402904029040
000800002d0402d0402d0402d040260402604026040260402d0402d0402d0402d040210402104021040210402d0402d0402d0402d040250402504025040250402d0402d0402d0402d04025040250402504025040
000800000000000000000000000028040280402804028040000000000000000000002804028040280402804000000000000000000000280402804028040280400000000000000000000028040280402804028040
000800002d0402d0402d0402d04024040240402404024040300503005030050300502405024050240502405030050300503005030050240502405024050240503005030050300503005024050240502405024050
000800000000000000000000000028050280502805028050000000000000000000002805028050280502805000000000000000000000280502805028050280500000000000000000000000000000000000000000
000800003000024000240002400024000300003000030000300002400024000240002400030000300003000030000240002400024000240003000030000300003000024000240000000000000000000000000000
000800003000030000300003000021000210002100021000210002100021000210002100021000210002100021000210002100021000240002400024000240002400024000240002400024000240002400024000
0008000024000240002400029000290002900029000290002900029000290002900029000290002900029000290002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002200022000
000800002200022000220002200022000220002300023000230002300023000230002300023000240002400024000240002400024000240002400024000240002400024000240002400024000240002900029000
00080000290002900029000290002900029000290002900029000290002900029000290002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0003000030000300003000030000
000800003000030000300003000030000300003000030000260002600026000260002600026000260002600028000280002800028000280002800028000280002900029000290002900029000290002900029000
000800000000000000000000000000000000000000000000270002700027000270000000000000000000000025000250002500025000000000000000000000002400024000240002400024000240002400024000
000800002400024000240002400024000240002400024000240002400024000240002400024000240002400029000290002900029000290002900029000290002900029000290002900029000290002900029000
00080000290002900029000290002900029000290002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d0002d000300003000030000
000800003000030000300003000030000300003000030000300003000030000300003000030000300003000030000300003000024000240002400024000240002400024000240002600026000260002600026000
0008000026000260002600026000260002600026000260002600026000000002e0002e0002e0002e0002e0002e0002e0002e0002e0002e0002e0002e0002e0002e0002e0002e0002d0002d0002d0002d0002d000
000800002d0002d0002d0002d0002d0002d0002d0002d0002d0002d000000002b0002b0002b0002b0002b0002b0002b0002b00029000290002900029000290002900029000290002d0002d0002d0002d0002d000
00081b002d0002d0002d0002d0002d0002d000000002b0002b0002b0002b000000002b0002b0002b0002b0002a0002a0002a0002a0002a0002a0002a0002a0000140001400014000140001400000000000000000
__music__
01 00014040
00 02034040
00 04054040
00 02064040
00 04074040
00 08064040
00 090a4040
00 0b0c4040
00 0d0e4040
00 0f104040
00 11404040
00 12404040
00 13404040
00 14404040
00 15164040
00 17184040
00 191a4040
00 1b1c4040
00 1d1e4040
00 1f204040
00 21224040
00 23244040
00 25264040
00 27284040
00 292a4040
00 2b2c4040
00 2d2e4040
00 2f304040
00 31324040
00 33404040
00 33404040
02 34404040
00 35404040
00 36404040
00 37404040
00 38404040
00 39404040
00 3a404040
00 3b404040
00 3c404040
00 3d404040
00 3e404040
00 3f404040